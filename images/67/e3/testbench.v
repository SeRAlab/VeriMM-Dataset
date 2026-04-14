`timescale 1ns/1ps

module reg4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg enable;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg4 dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            enable = 0;
            d = 4'b0000;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load value with enable high", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 4'hA;
            @(negedge clk);

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Verify enable signal (Hold value)", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            d = 4'h5;
            @(negedge clk);


            enable = 0;
            d = 4'hF;
            @(negedge clk);


            #1;



            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Synchronous Reset priority over Enable", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            d = 4'hC;
            reset = 1;
            @(negedge clk);


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Consecutive loads", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            d = 4'h1;
            @(negedge clk);
            d = 4'h2;
            @(negedge clk);
            d = 4'h4;
            @(negedge clk);
            d = 4'h8;
            @(negedge clk);


            #1;



            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Toggle enable", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            d = 4'h3;
            @(negedge clk);

            enable = 0;
            d = 4'h7;
            @(negedge clk);

            enable = 1;
            @(negedge clk);

            #1;


            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg4 Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, enable, reset, q);
    end

endmodule
