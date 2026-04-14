`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg CLK;
    reg [7:0] D;
    reg RW;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .D(D),
        .RW(RW),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        A = 3'b0;
        B = 3'b0;
        D = 8'b0;
        RW = 0;

        @(posedge CLK);
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Basic Write and Read", test_num);


        A = 3'd1; B = 3'd1; D = 8'hA5; RW = 1;
        @(posedge CLK);
        #2;


        RW = 0;
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Boundary Address (7, 7)", test_num);


        A = 3'd7; B = 3'd7; D = 8'h5A; RW = 1;
        @(posedge CLK);
        #2;


        RW = 0;
        #2;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Address Isolation", test_num);


        A = 3'd0; B = 3'd1; D = 8'h11; RW = 1;
        @(posedge CLK);
        #2;


        A = 3'd1; B = 3'd0; D = 8'h22; RW = 1;
        @(posedge CLK);
        #2;


        RW = 0; A = 3'd0; B = 3'd1;
        #2;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Overwrite Value", test_num);


        A = 3'd4; B = 3'd4; D = 8'hCC; RW = 1;
        @(posedge CLK);
        #2;


        D = 8'hDD;
        @(posedge CLK);
        #2;


        RW = 0;
        #2;
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: RW Control Sensitivity", test_num);


        A = 3'd2; B = 3'd2; D = 8'hEE; RW = 1;
        @(posedge CLK);
        #2;


        D = 8'hFF; RW = 0;
        @(posedge CLK);
        #2;


        A = 3'd2; B = 3'd2;
        #2;
        #1;

        check_outputs(8'hEE);
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
        $dumpvars(0,A, B, CLK, D, RW, Q);
    end

endmodule
