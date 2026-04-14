`timescale 1ns/1ps

module edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] in;
    reg reset_n;
    wire [9:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detector dut (
        .clk(clk),
        .in(in),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            in = 0;
            #15;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits Rising Edge (000 -> 3FF)", test_num);
            reset_dut();

            @(negedge clk);
            in = 10'h000;
            @(posedge clk);

            @(negedge clk);
            in = 10'h3FF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits Falling Edge (3FF -> 000)", test_num);
            reset_dut();

            @(negedge clk);
            in = 10'h3FF;
            @(posedge clk);

            @(negedge clk);
            in = 10'h000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Transitions (Lower rising, Upper falling)", test_num);
            reset_dut();

            @(negedge clk);
            in = 10'h3E0;
            @(posedge clk);

            @(negedge clk);
            in = 10'h01F;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h3FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Constant Input (No Transition)", test_num);
            reset_dut();
            @(negedge clk);
            in = 10'h155;
            @(posedge clk);
            @(negedge clk);
            in = 10'h155;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit Toggling", test_num);
            reset_dut();
            @(negedge clk);
            in = 10'h000;
            @(posedge clk);

            @(negedge clk);
            in = 10'h020;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h020);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous Reset Priority", test_num);
            reset_dut();
            @(negedge clk);
            in = 10'h000;
            @(posedge clk);

            @(negedge clk);
            in = 10'h3FF;

            reset_n = 0;
            #2;
            #1;

            check_outputs(10'h000);
            reset_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("edge_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [9:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset_n, out);
    end

endmodule
