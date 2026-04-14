`timescale 1ns/1ps

module N8080_RAM16X8D_regs_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [7:0] D;
    reg [2:0] DPRA;
    reg WCLK;
    reg WE;
    wire [7:0] DPO;
    wire [7:0] SPO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    N8080_RAM16X8D_regs dut (
        .A(A),
        .D(D),
        .DPRA(DPRA),
        .WCLK(WCLK),
        .WE(WE),
        .DPO(DPO),
        .SPO(SPO)
    );

    // Clock generation (10ns period)
    initial begin
        WCLK = 0;
        forever #5 WCLK = ~WCLK;
    end

        task reset_dut;

        integer i;
        begin
            A = 0;
            D = 0;
            DPRA = 0;
            WE = 0;


            for (i = 0; i < 5; i = i + 1) begin
                @(negedge WCLK);
                A = i;
                D = 8'h00;
                WE = 1;
            end
            @(negedge WCLK);
            WE = 0;
            A = 0;
            DPRA = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write/Read at Address 0");
            test_num = 1;
            reset_dut();

            @(negedge WCLK);
            A = 3'd0;
            D = 8'hA5;
            WE = 1;
            DPRA = 3'd0;

            @(negedge WCLK);
            WE = 0;
            #2;


            #1;



            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Boundary Access (Index 4)");
            test_num = 2;
            reset_dut();

            @(negedge WCLK);
            A = 3'd4;
            D = 8'h5A;
            WE = 1;
            DPRA = 3'd4;

            @(negedge WCLK);
            WE = 0;
            #2;

            #1;


            check_outputs(8'h5A, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Dual Port Read (A=1, DPRA=2)");
            test_num = 3;
            reset_dut();


            @(negedge WCLK);
            A = 3'd1; D = 8'h11; WE = 1;


            @(negedge WCLK);
            A = 3'd2; D = 8'h22; WE = 1;

            @(negedge WCLK);
            WE = 0;


            A = 3'd1;
            DPRA = 3'd2;
            #2;


            #1;



            check_outputs(8'h22, 8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Write Enable Disable Test");
            test_num = 4;
            reset_dut();


            @(negedge WCLK);
            A = 3'd3; D = 8'hCC; WE = 1;

            @(negedge WCLK);

            A = 3'd3; D = 8'hFF; WE = 0;
            DPRA = 3'd3;

            @(negedge WCLK);
            #2;


            #1;



            check_outputs(8'hCC, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Overwrite Address 0");
            test_num = 5;
            reset_dut();


            @(negedge WCLK);
            A = 3'd0; D = 8'h12; WE = 1;


            @(negedge WCLK);
            A = 3'd0; D = 8'h34; WE = 1;
            DPRA = 3'd0;

            @(negedge WCLK);
            WE = 0;
            #2;


            #1;



            check_outputs(8'h34, 8'h34);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("N8080_RAM16X8D_regs Testbench");
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
        input [7:0] expected_DPO;
        input [7:0] expected_SPO;
        begin
            if (expected_DPO === (expected_DPO ^ DPO ^ expected_DPO) &&
                expected_SPO === (expected_SPO ^ SPO ^ expected_SPO)) begin
                $display("PASS");
                $display("  Outputs: DPO=%h, SPO=%h",
                         DPO, SPO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DPO=%h, SPO=%h",
                         expected_DPO, expected_SPO);
                $display("  Got:      DPO=%h, SPO=%h",
                         DPO, SPO);
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
        $dumpvars(0,A, D, DPRA, WCLK, WE, DPO, SPO);
    end

endmodule
