`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg RESET;
    reg SHIFT_IN;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .RESET(RESET),
        .SHIFT_IN(SHIFT_IN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        @(negedge CLK);
        RESET = 1;
        LOAD = 0;
        DATA_IN = 8'h00;
        SHIFT_IN = 0;
        @(negedge CLK);
        RESET = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Reset Check", test_num);
        reset_dut();


        DATA_IN = 8'hFF;
        LOAD = 1;
        @(negedge CLK);


        RESET = 1;
        LOAD = 0;
        @(negedge CLK);
        RESET = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Parallel Load 0xA5", test_num);
        reset_dut();

        DATA_IN = 8'hA5;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Left Shift with SHIFT_IN=0", test_num);
        reset_dut();


        DATA_IN = 8'h81;
        LOAD = 1;
        @(negedge CLK);


        LOAD = 0;
        SHIFT_IN = 0;
        @(negedge CLK);

        #1;


        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Left Shift with SHIFT_IN=1", test_num);
        reset_dut();


        DATA_IN = 8'h55;
        LOAD = 1;
        @(negedge CLK);


        LOAD = 0;
        SHIFT_IN = 1;
        @(negedge CLK);

        #1;


        check_outputs(8'hAB);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in 8 ones to fill register", test_num);
        reset_dut();

        LOAD = 0;
        SHIFT_IN = 1;

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge CLK);
        end

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Priority Check (LOAD and SHIFT active)", test_num);
        reset_dut();




        DATA_IN = 8'hEE;
        LOAD = 1;
        SHIFT_IN = 1;
        @(negedge CLK);

        #1;


        check_outputs(8'hEE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequence shift 1010", test_num);
        reset_dut();

        LOAD = 0;
        SHIFT_IN = 1; @(negedge CLK);
        SHIFT_IN = 0; @(negedge CLK);
        SHIFT_IN = 1; @(negedge CLK);
        SHIFT_IN = 0; @(negedge CLK);

        #1;


        check_outputs(8'h0A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,CLK, DATA_IN, LOAD, RESET, SHIFT_IN, Q);
    end

endmodule
