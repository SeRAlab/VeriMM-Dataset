`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .reset(reset),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting the system...");
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Traversal to Completion", test_num);
            reset_dut();

            timeout = 0;

            while (!done && timeout < 20) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;


            #1;



            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Traversal", test_num);
            reset_dut();


            repeat(2) @(posedge clk);


            $display("  Interrupting with reset...");
            reset_dut();

            timeout = 0;
            while (!done && timeout < 20) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Traversals", test_num);


            reset_dut();
            while (!done) @(posedge clk);


            $display("  Starting second traversal...");
            reset_dut();

            timeout = 0;
            while (!done && timeout < 20) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Output Stability Post-Traversal", test_num);
            reset_dut();


            while (!done) @(posedge clk);


            repeat(5) @(posedge clk);

            #1;

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, reset, data_out, done);
    end

endmodule
