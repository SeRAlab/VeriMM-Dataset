`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] command;
    wire [3:0] command_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .command(command),
        .command_out(command_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Command = 0xA (Inversion check)", test_num);
        command = 4'hA;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Command = 0x0 (Passthrough check)", test_num);
        command = 4'h0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Command = 0xF (Passthrough check)", test_num);
        command = 4'hF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Command = 0x5 (Passthrough check)", test_num);
        command = 4'h5;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Command = 0x9 (Passthrough check)", test_num);
        command = 4'h9;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Command = 0xB (Passthrough check)", test_num);
        command = 4'hB;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Command = 0x1 (Passthrough check)", test_num);
        command = 4'h1;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Command = 0xE (Passthrough check)", test_num);
        command = 4'hE;
        #1;

        check_outputs(4'hE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        input [3:0] expected_command_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_command_out === (expected_command_out ^ command_out ^ expected_command_out)) begin
                $display("PASS");
                $display("  Outputs: command_out=%h",
                         command_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_out=%h",
                         expected_command_out);
                $display("  Got:      command_out=%h",
                         command_out);
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
