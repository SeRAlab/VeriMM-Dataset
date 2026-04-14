`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [7:0] D;
    reg OE;
    reg WE;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .A(A),
        .D(D),
        .OE(OE),
        .WE(WE),
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
            A = 3'd0;
            D = 8'd0;
            OE = 1'b0;
            WE = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            A = 3'd3; D = 8'hAA; WE = 1; OE = 0;
            @(posedge clk); #1;


            WE = 0; OE = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-Impedance State (OE=0, WE=0)", test_num);
            reset_dut();


            A = 3'd1; D = 8'h55; WE = 1; OE = 0;
            @(posedge clk); #1;


            WE = 0; OE = 0;
            #5;

            #1;


            check_outputs(8'hzz);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Isolation (Multiple Addrs)", test_num);
            reset_dut();


            A = 3'd0; D = 8'h11; WE = 1; OE = 0;
            @(posedge clk); #1;


            A = 3'd7; D = 8'h22; WE = 1; OE = 0;
            @(posedge clk); #1;


            A = 3'd0; WE = 0; OE = 1;
            @(posedge clk); #1;



            A = 3'd7;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Overwrite", test_num);
            reset_dut();


            A = 3'd4; D = 8'hCC; WE = 1; OE = 0;
            @(posedge clk); #1;


            A = 3'd4; D = 8'h33; WE = 1; OE = 0;
            @(posedge clk); #1;


            WE = 0; OE = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous WE and OE", test_num);
            reset_dut();


            A = 3'd2; D = 8'h99; WE = 1; OE = 1;
            @(posedge clk); #1;




            #1;





            check_outputs(8'h99);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        $dumpvars(0,A, D, OE, WE, clk, Q);
    end

endmodule
