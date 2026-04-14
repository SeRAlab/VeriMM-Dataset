`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CS;
    reg [3:0] D;
    reg WE;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .CS(CS),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CS = 0;
            WE = 0;
            D = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CS=0, checking default output", test_num);
            reset_dut();
            CS = 0;
            D = 4'hF;
            WE = 1;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write (4'hA) and Read", test_num);
            reset_dut();


            CS = 1;
            WE = 1;
            D = 4'hA;
            @(posedge CLK);
            #2;


            WE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write (4'h5) and Read", test_num);
            reset_dut();


            CS = 1;
            WE = 1;
            D = 4'h5;
            @(posedge CLK);
            #2;


            WE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write attempt with CS=0", test_num);
            reset_dut();


            CS = 1; WE = 1; D = 4'h7;
            @(posedge CLK); #2;


            CS = 0; WE = 1; D = 4'hE;
            @(posedge CLK); #2;


            CS = 1; WE = 0;
            @(posedge CLK); #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Output zeroing when CS de-asserted", test_num);
            reset_dut();


            CS = 1; WE = 1; D = 4'hB;
            @(posedge CLK); #2;


            CS = 0;
            #5;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence test", test_num);
            reset_dut();

            CS = 1; WE = 1; D = 4'h3;
            @(posedge CLK); #2;

            CS = 1; WE = 0;
            repeat(5) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values 4'h0 and 4'hF", test_num);
            reset_dut();


            CS = 1; WE = 1; D = 4'h0;
            @(posedge CLK); #2;
            WE = 0;
            @(posedge CLK); #2;
            if (Q !== 4'h0) begin $display("Subtest h0 failed"); fail_count++; end


            WE = 1; D = 4'hF;
            @(posedge CLK); #2;
            WE = 0;
            @(posedge CLK); #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: WE=0 Write Protection", test_num);
            reset_dut();


            CS = 1; WE = 1; D = 4'h1;
            @(posedge CLK); #2;


            WE = 0; D = 4'h9;
            @(posedge CLK); #2;

            #1;


            check_outputs(4'h1);
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
        testcase008();
        
        
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
        input [3:0] expected_Q;
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
        $dumpvars(0,CLK, CS, D, WE, Q);
    end

endmodule
