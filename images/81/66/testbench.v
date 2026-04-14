`timescale 1ns/1ps

module reg12_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] d;
    reg enable;
    reg reset;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg12 dut (
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
            @(posedge clk);
            reset <= 1;
            enable <= 0;
            d <= 0;
            @(posedge clk);
            reset <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0xFFF with enable high", test_num);
            reset_dut();
            @(negedge clk);
            enable <= 1;
            d <= 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify data hold when enable is low", test_num);
            reset_dut();


            @(negedge clk);
            enable <= 1;
            d <= 12'hABC;
            @(posedge clk);


            @(negedge clk);
            enable <= 0;
            d <= 12'h123;
            @(posedge clk);
            #1;


            #1;



            check_outputs(12'hABC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous reset takes priority over enable", test_num);
            reset_dut();


            @(negedge clk);
            reset <= 1;
            enable <= 1;
            d <= 12'h555;
            @(posedge clk);
            #1;


            #1;



            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Loading pattern 0xAAA", test_num);
            reset_dut();

            @(negedge clk);
            enable <= 1;
            d <= 12'hAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'hAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Continuous loading", test_num);
            reset_dut();

            @(negedge clk);
            enable <= 1;
            d <= 12'h111;
            @(posedge clk);

            @(negedge clk);
            d <= 12'h222;
            @(posedge clk);

            @(negedge clk);
            d <= 12'h333;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h333);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg12 Testbench");
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
        input [11:0] expected_q;
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
