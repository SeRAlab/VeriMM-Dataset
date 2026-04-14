`timescale 1ns/1ps

module reg32_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg en;
    reg reset;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg32 dut (
        .clk(clk),
        .d(d),
        .en(en),
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
            reset = 1;
            en = 0;
            d = 0;
            #12;
            reset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Write Operation", test_num);
            reset_dut();

            @(posedge clk);
            d = 32'hDEADBEEF;
            en = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable Gating Check", test_num);
            reset_dut();


            @(posedge clk);
            d = 32'hAAAA_5555;
            en = 1;

            @(posedge clk);
            #1;

            en = 0;
            d = 32'hFFFF_FFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Asynchronous Reset Priority", test_num);
            reset_dut();


            @(posedge clk);
            d = 32'h1234_5678;
            en = 1;

            @(posedge clk);
            #2;

            reset = 1;
            #1;

            #1;


            check_outputs(32'h0000_0000);

            #5;
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential Data Updates", test_num);
            reset_dut();

            en = 1;
            @(posedge clk); d = 32'h1;
            @(posedge clk); d = 32'h2;
            @(posedge clk); d = 32'h3;
            @(posedge clk); d = 32'h4;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg32 Testbench");
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, d, en, reset, q);
    end

endmodule
