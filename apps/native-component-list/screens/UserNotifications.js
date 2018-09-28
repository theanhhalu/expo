import React from 'react';
import { Notifications } from "expo";
import { StyleSheet, Text, View, Button } from "react-native";

export default class UserNotificationsScreen extends React.Component {
  static navigationOptions = {
    title: 'Notifications',
  };

  state = {
    gotNotification : false,
    expoPushToken: null,
    actionId : null,
    userText : null
  };

  async componentWillMount() {
    await Notifications.addCategoryAsync('super-category',
     [
       ['touch_action', 'touch', Notifications.RED + Notifications.UNLOCK],
       ['add_action', 'add', 0, 'button_name', 'default text']
     ]
   );

    this._notificationListener = Notifications.addListener((e) => {
      this.setState({gotNotification : true, actionId : e.actionId, userText : e.userText});
      console.log("event received");
    });
  }

  async componentDidMount() {
     this.setState({expoPushToken : await Notifications.getExpoPushTokenAsync()});
  }

  componentWillUnmount() {
    this._notificationListener.remove();
    this._notificationListener = null;
  }

  _onButtonPress = () => {
    Notifications.presentLocalNotificationAsync({
      title: "notification",
      body: "notification-body",
      data: { scheduledAt: new Date().getTime() },
      categoryId: 'super-category'
    });
  };

  _schedule = () => {
    Notifications.scheduleLocalNotificationWithMatchAsync(
      {
        title: "notification",
        body: "notification-body",
        data: { scheduledAt: new Date().getTime() },
      },
      {
        hour: 12,
        minute: 4,
      }
   );
  };

  _waitTenSec = async () => {
    this.notificationID = await Notifications.scheduleLocalNotificationWithTimeIntervalAsync(
      {
        title: "notification",
        body: "notification-body",
        data: { scheduledAt: new Date().getTime() },
      },
      {
        "time-interval": 10,
      }
   );
  };

  _cancelWithId = () => {
    console.log(this.notificationID);
    Notifications.cancelScheduledNotificationAsync(this.notificationID);
  }

  render() {
    return (
      <View style={styles.container}>
        <Text>
          {this.state.gotNotification}
        </Text>
        <Text>
        notifications example
        </Text>
        <Button onPress={this._onButtonPress} title="trigger"/>
        <Button onPress={this._schedule} title="schedule"/>
        <Button onPress={this._waitTenSec} title="10 sec"/>
        <Button onPress={this._cancelWithId} title="cancel"/>
        <Text> ExpoPushToken: {this.state.expoPushToken} </Text>
        <Text> categoryId: {this.state.categoryId} </Text>
        <Text> actionId: {this.state.actionId} </Text>
        <Text> userInput: {this.state.userText} </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: 15,
    alignItems: "center",
    justifyContent: "center"
  }
});
