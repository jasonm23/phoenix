const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

const config = {
  title: 'Phoenix',
  url: 'https://kasper.github.io',
  baseUrl: '/phoenix/',
  favicon: 'img/favicon.ico',
  organizationName: 'kasper',
  projectName: 'phoenix',
  plugins: [require.resolve('docusaurus-lunr-search')],
  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/kasper/phoenix/tree/master/docs/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
  themeConfig: {
    navbar: {
      title: 'Phoenix',
      logo: {
        alt: 'Phoenix',
        src: 'img/logo.png',
      },
      items: [
        {
          href: 'https://github.com/kasper/phoenix/blob/master/CHANGELOG.md',
          label: 'Changelog',
          position: 'right',
        },
        {
          href: 'https://github.com/kasper/phoenix/issues/',
          label: 'Report an Issue',
          position: 'right',
        },
        {
          href: 'https://github.com/kasper/phoenix/',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    prism: {
      theme: lightCodeTheme,
      darkTheme: darkCodeTheme,
    },
  },
};

module.exports = config;
