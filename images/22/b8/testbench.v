`timescale 1ns/1ps

module nvme_command_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] command_in;
    reg reset;
    reg valid;
    wire [31:0] command_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_register dut (
        .clk(clk),
        .command_in(command_in),
        .reset(reset),
        .valid(valid),
        .command_out(command_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            command_in = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid Load Check", test_num);
            reset_dut();

            command_in = 32'hDEADBEEF;
            valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Hold (Valid=0) Check", test_num);
            reset_dut();


            command_in = 32'hAAAA5555;
            valid = 1;
            @(posedge clk);
            #1;


            command_in = 32'hFFFFFFFF;
            valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Successive Writes Check", test_num);
            reset_dut();


            command_in = 32'h11111111;
            valid = 1;
            @(posedge clk);
            #1;


            command_in = 32'h22222222;
            valid = 1;
            @(posedge clk);
            #1;


            command_in = 32'h33333333;
            valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h33333333);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input change with no Valid pulse", test_num);
            reset_dut();

            command_in = 32'h12345678;
            valid = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_command_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, command_in, reset, valid, command_out);
    end

endmodule
