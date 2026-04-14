`timescale 1ns/1ps

module Register5bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [4:0] in;
    reg load;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Register5bit dut (
        .clk(clk),
        .clr(clr),
        .in(in),
        .load(load),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            load = 0;
            in = 5'b0;
            #15;
            clr = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Load Operation", test_num);
            reset_dut();

            @(negedge clk);
            in = 5'h1A;
            load = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Retention when load=0", test_num);
            reset_dut();


            @(negedge clk);
            in = 5'h0F;
            load = 1;
            @(posedge clk);


            @(negedge clk);
            load = 0;
            in = 5'h1F;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous Clear Priority", test_num);
            reset_dut();


            @(negedge clk);
            in = 5'h15;
            load = 1;
            @(posedge clk);


            #3;
            clr = 1;
            #1;

            #1;


            check_outputs(5'h00);


            clr = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Loading Maximum Value (5'h1F)", test_num);
            reset_dut();

            @(negedge clk);
            in = 5'h1F;
            load = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Loads", test_num);
            reset_dut();


            @(negedge clk);
            in = 5'h05;
            load = 1;
            @(posedge clk);


            @(negedge clk);
            in = 5'h10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Register5bit Testbench");
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
        input [4:0] expected_out;
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
        $dumpvars(0,clk, clr, in, load, out);
    end

endmodule
