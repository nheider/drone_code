from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_xml.launch_description_sources import XMLLaunchDescriptionSource
from launch_ros.actions import Node
from launch_ros.substitutions import FindPackageShare
from launch.substitutions import PathJoinSubstitution

def generate_launch_description():
    siyi_a8_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            PathJoinSubstitution([
                FindPackageShare('siyi_a8_ros2'),
                'launch',
                'siyi_a8.launch.py'
            ])
        ])
    )
    
    foxglove_bridge_launch = IncludeLaunchDescription(
        XMLLaunchDescriptionSource([
            PathJoinSubstitution([
                FindPackageShare('foxglove_bridge'),
                'launch',
                'foxglove_bridge_launch.xml'
            ])
        ])
    )
    
    display_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            PathJoinSubstitution([
                FindPackageShare('drone_description'),
                'launch',
                'display.launch.py'
            ])
        ])
    )
    
    apriltag_node = Node(
        package='apriltag_ros',
        executable='apriltag_node',
        name='apriltag_node',
        remappings=[
            ('image_rect', '/siyi_a8/image_raw'),
            ('camera_info', '/siyi_a8/camera_info')
        ],
        parameters=[
            PathJoinSubstitution([
                FindPackageShare('apriltag_ros'),
                'cfg',
                'tag_25h9_0.yaml'
            ])
        ]
    )
    
    return LaunchDescription([
        siyi_a8_launch,
        foxglove_bridge_launch,
        display_launch,
        apriltag_node
    ])
