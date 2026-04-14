`timescale 1ns/1ps

module nvme_command_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] command_input;
    wire [15:0] command_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_decoder dut (
        .command_input(command_input),
        .command_output(command_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input 5'b00000 (Read)", test_num);
        command_input = 5'b00000;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input 5'b00001 (Write)", test_num);
        command_input = 5'b00001;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input 5'b00010 (Flush)", test_num);
        command_input = 5'b00010;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input 5'b00011 (Identify)", test_num);
        command_input = 5'b00011;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input 5'b00100 (Delete)", test_num);
        command_input = 5'b00100;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input 5'b00101 (Invalid - Boundary)", test_num);
        command_input = 5'b00101;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input 5'b01111 (Invalid - Mid-Range)", test_num);
        command_input = 5'b01111;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input 5'b11111 (Invalid - Maximum)", test_num);
        command_input = 5'b11111;
        #1;

        check_outputs(16'h0000);
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
        testcase008();
        
        
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
        input [15:0] expected_command_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_command_output === (expected_command_output ^ command_output ^ expected_command_output)) begin
                $display("PASS");
                $display("  Outputs: command_output=%h",
                         command_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_output=%h",
                         expected_command_output);
                $display("  Got:      command_output=%h",
                         command_output);
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
