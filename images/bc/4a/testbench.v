`timescale 1ns/1ps

module reg18_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [17:0] d;
    reg load;
    reg reset;
    wire [17:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg18 dut (
        .clk(clk),
        .d(d),
        .load(load),
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
            reset = 1;
            load = 0;
            d = 0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Reset functionality", test_num);
            reset_dut();
            #1;

            check_outputs(18'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load data 0x12345", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            d = 18'h12345;
            @(posedge clk);
            load = 0;
            d = 0;
            #1;
            #1;

            check_outputs(18'h12345);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load max value 0x3FFFF", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            d = 18'h3FFFF;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(18'h3FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify data is held when load=0", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            d = 18'h0AAAA;
            @(posedge clk);

            load = 0;
            d = 18'h15555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(18'h0AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority over Load", test_num);
            reset_dut();
            @(posedge clk);
            reset = 1;
            load = 1;
            d = 18'h35555;
            @(posedge clk);
            reset = 0;
            load = 0;
            #1;
            #1;

            check_outputs(18'h00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg18 Testbench");
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
        input [17:0] expected_q;
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
        $dumpvars(0,clk, d, load, reset, q);
    end

endmodule
