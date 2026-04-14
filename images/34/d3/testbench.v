`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [7:0] D;
    reg RE;
    reg WE;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .A(A),
        .D(D),
        .RE(RE),
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
            A <= 3'b0;
            D <= 8'b0;
            RE <= 1'b0;
            WE <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read Address 0", test_num);


            @(negedge clk);
            A <= 3'd0;
            D <= 8'hA5;
            WE <= 1'b1;
            RE <= 1'b0;
            @(negedge clk);
            WE <= 1'b0;


            @(negedge clk);
            RE <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read Address 7", test_num);


            @(negedge clk);
            A <= 3'd7;
            D <= 8'h5A;
            WE <= 1'b1;
            RE <= 1'b0;
            @(negedge clk);
            WE <= 1'b0;


            @(negedge clk);
            RE <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Value", test_num);


            @(negedge clk);
            A <= 3'd3;
            D <= 8'h11;
            WE <= 1'b1;
            @(negedge clk);

            D <= 8'h22;
            @(negedge clk);
            WE <= 1'b0;


            RE <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Address Independence", test_num);


            @(negedge clk);
            A <= 3'd1; D <= 8'hAA; WE <= 1'b1;
            @(negedge clk);

            A <= 3'd2; D <= 8'hBB; WE <= 1'b1;
            @(negedge clk);
            WE <= 1'b0;


            RE <= 1'b1;
            A <= 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence Check", test_num);


            @(negedge clk);
            A <= 3'd4; D <= 8'hCC; WE <= 1'b1;
            @(negedge clk);
            WE <= 1'b0;


            repeat(5) @(posedge clk);


            @(negedge clk);
            RE <= 1'b1;
            A <= 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Zeros", test_num);

            @(negedge clk);
            A <= 3'd5; D <= 8'h00; WE <= 1'b1;
            @(negedge clk);
            WE <= 1'b0;
            RE <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Ones", test_num);

            @(negedge clk);
            A <= 3'd6; D <= 8'hFF; WE <= 1'b1;
            @(negedge clk);
            WE <= 1'b0;
            RE <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,A, D, RE, WE, clk, Q);
    end

endmodule
