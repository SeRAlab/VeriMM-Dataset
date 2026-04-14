`timescale 1ns/1ps

module reg64_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] d;
    reg reset;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg64 dut (
        .clk(clk),
        .d(d),
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
            @(posedge clk);
            reset <= 1;
            d <= 64'h0;
            @(posedge clk);
            reset <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Initialization", test_num);

            @(posedge clk);
            d <= 64'hFFFFFFFFFFFFFFFF;
            reset <= 0;
            @(posedge clk);
            reset <= 1;
            @(posedge clk);
            reset <= 0;
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Data Write", test_num);
            reset_dut();
            d <= 64'hA5A5A5A55A5A5A5A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hA5A5A5A55A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write All Ones", test_num);
            reset_dut();
            d <= 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write All Zeros", test_num);
            reset_dut();

            d <= 64'h1;
            @(posedge clk);

            d <= 64'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Value Stability between edges", test_num);
            reset_dut();
            d <= 64'h123456789ABCDEF0;
            @(posedge clk);
            #2;
            d <= 64'h0;
            #2;

            #1;


            check_outputs(64'h123456789ABCDEF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern", test_num);
            reset_dut();
            d <= 64'h5555555555555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg64 Testbench");
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
        input [63:0] expected_q;
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
        $dumpvars(0,clk, d, reset, q);
    end

endmodule
