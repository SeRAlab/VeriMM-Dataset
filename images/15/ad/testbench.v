`timescale 1ns/1ps

module rrt_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] new_x;
    reg [9:0] new_y;
    reg reset;
    reg valid;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_tree dut (
        .clk(clk),
        .new_x(new_x),
        .new_y(new_y),
        .reset(reset),
        .valid(valid),
        .success(success)
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
            new_x = 0;
            new_y = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Adding a single valid point close to origin (0,0)", test_num);
            new_x = 10'd20;
            new_y = 10'd20;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Adding a single point too far from origin", test_num);
            new_x = 10'd500;
            new_y = 10'd500;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Adding 5 consecutive valid points", test_num);
            for (i = 1; i <= 5; i = i + 1) begin
                new_x = i * 10'd15;
                new_y = i * 10'd15;
                valid = 1;
                @(posedge clk);
                valid = 0;
                repeat(2) @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Sequence with an invalid jump at the 3rd point", test_num);


            new_x = 10'd10; new_y = 10'd10; valid = 1; @(posedge clk); valid = 0; repeat(2) @(posedge clk);

            new_x = 10'd20; new_y = 10'd20; valid = 1; @(posedge clk); valid = 0; repeat(2) @(posedge clk);

            new_x = 10'd800; new_y = 10'd800; valid = 1; @(posedge clk); valid = 0; repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Verify reset clears internal state", test_num);


            new_x = 10'd30; new_y = 10'd30; valid = 1; @(posedge clk); valid = 0; repeat(2) @(posedge clk);


            reset_dut();


            new_x = 10'd15; new_y = 10'd15; valid = 1; @(posedge clk); valid = 0; repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_tree Testbench");
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
        input expected_success;
        begin
            if (expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: success=%b",
                         success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: success=%b",
                         expected_success);
                $display("  Got:      success=%b",
                         success);
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
        $dumpvars(0,clk, new_x, new_y, reset, valid, success);
    end

endmodule
