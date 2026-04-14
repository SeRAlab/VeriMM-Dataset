`timescale 1ns/1ps

module nvme_command_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] command;
    wire [2:0] command_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_decoder dut (
        .command(command),
        .command_type(command_type)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        command = 5'b00000;
        $display("Test %0d: Input Command 00000 (Read)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        command = 5'b00001;
        $display("Test %0d: Input Command 00001 (Write)", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        command = 5'b00010;
        $display("Test %0d: Input Command 00010 (Flush)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        command = 5'b00011;
        $display("Test %0d: Input Command 00011 (Invalid)", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        command = 5'b00100;
        $display("Test %0d: Input Command 00100 (Other Type - Boundary 4)", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        command = 5'b01100;
        $display("Test %0d: Input Command 01100 (Other Type - Mid range 12)", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        command = 5'b11111;
        $display("Test %0d: Input Command 11111 (Other Type - Boundary 31)", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [2:0] expected_command_type;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_command_type === (expected_command_type ^ command_type ^ expected_command_type)) begin
                $display("PASS");
                $display("  Outputs: command_type=%h",
                         command_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_type=%h",
                         expected_command_type);
                $display("  Got:      command_type=%h",
                         command_type);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
