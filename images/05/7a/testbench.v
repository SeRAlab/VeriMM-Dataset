`timescale 1ns/1ps

module nvme_command_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] opcode;
    wire [2:0] command_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_decoder dut (
        .opcode(opcode),
        .command_type(command_type)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Opcode 00000 (Read)", test_num);
        opcode = 5'b00000;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Opcode 00001 (Write)", test_num);
        opcode = 5'b00001;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Opcode 00010 (Ident)", test_num);
        opcode = 5'b00010;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Opcode 00011 (Reserved)", test_num);
        opcode = 5'b00011;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Opcode 00100 (Reserved)", test_num);
        opcode = 5'b00100;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Opcode 00101 (Invalid)", test_num);
        opcode = 5'b00101;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Opcode 10101 (Invalid)", test_num);
        opcode = 5'b10101;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Opcode 11111 (Invalid)", test_num);
        opcode = 5'b11111;
        #1;

        check_outputs(3'd4);
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
