`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR;
    reg [31:0] D;
    reg E;
    reg clk_IBUF_BUFG;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .D(D),
        .E(E),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk_IBUF_BUFG = 0;
        forever #5 clk_IBUF_BUFG = ~clk_IBUF_BUFG;
    end

        task reset_dut;

        begin


            @(posedge clk_IBUF_BUFG);
            E = 1;
            AR = 0;
            D = 32'h0;
            @(posedge clk_IBUF_BUFG);
            AR = 1;
            D = 32'h0;
            @(posedge clk_IBUF_BUFG);
            E = 0;
            @(negedge clk_IBUF_BUFG);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Write and Read Address 0", test_num);


            @(posedge clk_IBUF_BUFG);
            E = 1; AR = 0; D = 32'hDEADBEEF;
            @(posedge clk_IBUF_BUFG);
            E = 0;


            @(negedge clk_IBUF_BUFG);
            AR = 0; E = 0;
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Write and Read Address 1", test_num);


            @(posedge clk_IBUF_BUFG);
            E = 1; AR = 1; D = 32'hCAFEBABE;
            @(posedge clk_IBUF_BUFG);
            E = 0;


            @(negedge clk_IBUF_BUFG);
            AR = 1; E = 0;
            #2;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Verify storage independence (Check AR=0)", test_num);


            @(posedge clk_IBUF_BUFG);
            E = 1; AR = 0; D = 32'h11111111;
            @(posedge clk_IBUF_BUFG);
            AR = 1; D = 32'h22222222;
            @(posedge clk_IBUF_BUFG);
            E = 0;


            @(negedge clk_IBUF_BUFG);
            AR = 0; E = 0;
            #2;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Verify storage independence (Check AR=1)", test_num);


            @(posedge clk_IBUF_BUFG);
            E = 1; AR = 0; D = 32'h11111111;
            @(posedge clk_IBUF_BUFG);
            AR = 1; D = 32'h22222222;
            @(posedge clk_IBUF_BUFG);
            E = 0;


            @(negedge clk_IBUF_BUFG);
            AR = 1; E = 0;
            #2;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Verify E=0 prevents writing", test_num);


            @(posedge clk_IBUF_BUFG);
            E = 0; AR = 0; D = 32'hFFFFFFFF;
            @(posedge clk_IBUF_BUFG);


            @(negedge clk_IBUF_BUFG);
            AR = 0; E = 0;
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Verify read timing and E dependency", test_num);


            @(posedge clk_IBUF_BUFG);
            E = 1; AR = 0; D = 32'h5555AAAA;
            @(posedge clk_IBUF_BUFG);
            E = 0;


            AR = 0; E = 0;
            @(negedge clk_IBUF_BUFG);
            #2;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,AR, D, E, clk_IBUF_BUFG, Q);
    end

endmodule
