`timescale 1ns/1ps

module nvme_command_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command;
    reg reset;
    wire ready;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_processor dut (
        .clk(clk),
        .command(command),
        .reset(reset),
        .ready(ready),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            command = 4'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Valid Command (4'h1)", test_num);
            reset_dut();

            @(posedge clk);
            command = 4'h1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Invalid Command (4'hF)", test_num);
            reset_dut();

            @(posedge clk);
            command = 4'hF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Ready Toggle Mechanism", test_num);
            reset_dut();


            @(posedge clk);
            command = 4'h2;
            @(posedge clk);


            @(posedge clk);
            command = 4'h3;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Command Completion/Idle", test_num);
            reset_dut();

            @(posedge clk);
            command = 4'h5;
            @(posedge clk);
            command = 4'h0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_processor Testbench");
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
        input expected_ready;
        input expected_valid;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, valid=%b",
                         ready, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, valid=%b",
                         expected_ready, expected_valid);
                $display("  Got:      ready=%b, valid=%b",
                         ready, valid);
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
        $dumpvars(0,clk, command, reset, ready, valid);
    end

endmodule
