`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg EN;
    reg WL;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .D(D),
        .EN(EN),
        .WL(WL),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D <= 8'b0;
            EN <= 0;
            WL <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read", test_num);


            D <= 8'hAA;
            EN <= 1;
            WL <= 1;
            @(posedge clk);
            #1;


            WL <= 0;
            D <= 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: WL Gating Check", test_num);


            D <= 8'h55;
            EN <= 1;
            WL <= 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: EN Gating Check", test_num);


            D <= 8'hFF;
            EN <= 0;
            WL <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Successive Write and Retention", test_num);


            D <= 8'h12;
            EN <= 1;
            WL <= 1;
            @(posedge clk);
            #1;


            D <= 8'h34;
            EN <= 1;
            WL <= 1;
            @(posedge clk);
            #1;


            WL <= 0;
            D <= 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h34);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Value Test", test_num);


            D <= 8'hFF;
            EN <= 1;
            WL <= 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFF);


            D <= 8'h00;
            EN <= 1;
            WL <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Read Verification (WL=0, EN=1)", test_num);


            D <= 8'h7E;
            EN <= 1;
            WL <= 1;
            @(posedge clk);
            #1;


            WL <= 0;
            D <= 8'hA5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h7E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,D, EN, WL, clk, Q);
    end

endmodule
