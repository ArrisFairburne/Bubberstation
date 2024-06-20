import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Dimmer, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export const NtosJobManager = (props) => {
  return (
    <NtosWindow width={400} height={620}>
      <NtosWindow.Content scrollable>
        <NtosJobManagerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosJobManagerContent = (props) => {
  const { act, data } = useBackend();
  const { authed, cooldown, slots = [], prioritized = [] } = data;

  const [selfServeBlocked, setSelfServeBlocked] = useState('');
  const updateSelfServeBlocked = () => {
    setSelfServeBlocked();
  };

  if (!authed) {
    return (
      <NoticeBox>
        Current ID does not have access permissions to change job slots.
      </NoticeBox>
    );
  }
  return (
    <Section>
      {cooldown > 0 && (
        <Dimmer>
          <Box bold textAlign="center" fontSize="20px">
            On Cooldown: {cooldown}s
          </Box>
        </Dimmer>
      )}
      <Table>
        {/* BUBBERSTATION EDIT ADD BEGIN - Crew Self Serve */}
        <Table.Row header>
          <Table.Cell>Crew Self Serve</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>
            <Button.Checkbox
              checked={selfServeBlocked}
              onClick={(e) => {
                updateSelfServeBlocked(!selfServeBlocked);
              }}
              tooltip="Enable or disable self serve title edits by crew."
            >
              Block crew self serve title editing
            </Button.Checkbox>
          </Table.Cell>
        </Table.Row>
        {/* BUBBERSTATION EDIT ADD END - Crew Self Serve */}
        <Table.Row header>
          <Table.Cell>Prioritized</Table.Cell>
          <Table.Cell>Slots</Table.Cell>
        </Table.Row>
        {slots.map((slot) => (
          <Table.Row key={slot.title} className="candystripe">
            <Table.Cell bold>
              <Button.Checkbox
                fluid
                content={slot.title}
                disabled={slot.total <= 0}
                checked={slot.total > 0 && prioritized.includes(slot.title)}
                onClick={() =>
                  act('PRG_priority', {
                    target: slot.title,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell collapsing>
              {slot.current} / {slot.total}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                content="Open"
                disabled={!slot.status_open}
                onClick={() =>
                  act('PRG_open_job', {
                    target: slot.title,
                  })
                }
              />
              <Button
                content="Close"
                disabled={!slot.status_close}
                onClick={() =>
                  act('PRG_close_job', {
                    target: slot.title,
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
