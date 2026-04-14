`timescale 1ns/1ps

module sata_command_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command;
    reg rst;
    wire valid_command;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_command_decoder dut (
        .clk(clk),
        .command(command),
        .rst(rst),
        .valid_command(valid_command)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            command = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Command = 0 (Invalid)", test_num);
            reset_dut();
            command = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Command = 1 (Valid)", test_num);
            reset_dut();
            command = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Command = 4 (Valid)", test_num);
            reset_dut();
            command = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Command = 8 (Valid)", test_num);
            reset_dut();
            command = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Command = 9 (Invalid)", test_num);
            reset_dut();
            command = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Command = 15 (Invalid)", test_num);
            reset_dut();
            command = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority (Valid command but RST active)", test_num);
            reset_dut();
            command = 4'd5;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_command_decoder Testbench");
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
        input expected_valid_command;
        begin
            if (expected_valid_command === (expected_valid_command ^ valid_command ^ expected_valid_command)) begin
                $display("PASS");
                $display("  Outputs: valid_command=%b",
                         valid_command);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_command=%b",
                         expected_valid_command);
                $display("  Got:      valid_command=%b",
                         valid_command);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, command, rst, valid_command);
    end

endmodule
