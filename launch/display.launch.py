from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import Command, LaunchConfiguration
from launch_ros.actions import Node
from launch_ros.substitutions import FindPackageShare
from launch_ros.parameter_descriptions import ParameterValue
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    pkg_share = FindPackageShare(package='drone_description').find('drone_description')
    default_model_path = os.path.join(pkg_share, 'src', 'description', 'drone_description.urdf')
    
    robot_state_publisher_node = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        parameters=[{'robot_description': ParameterValue(
            Command(['xacro ', LaunchConfiguration('model')]),
            value_type=str
        )}]
    )
    
    return LaunchDescription([
        DeclareLaunchArgument(name='model', default_value=default_model_path, 
                              description='Absolute path to robot model file'),
        robot_state_publisher_node
    ])
