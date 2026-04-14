`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg SER_IN;
    wire [7:0] Q;
    wire SER_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .SER_IN(SER_IN),
        .Q(Q),
        .SER_OUT(SER_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1;
            DATA_IN = 8'h00;
            SER_IN = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 0xAA", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 8'hAA;
            @(posedge CLK);
            #1;
            LOAD = 0;

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 0x55", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 8'h55;
            @(posedge CLK);
            #1;
            LOAD = 0;

            #1;


            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in '1' once", test_num);
            reset_dut();
            LOAD = 0;
            SER_IN = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 0x0F (4 bits)", test_num);
            reset_dut();
            LOAD = 0;
            SER_IN = 1;
            repeat(4) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h0F, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift out MSB", test_num);
            reset_dut();

            LOAD = 1;
            DATA_IN = 8'h80;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SER_IN = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill register with 1s via shifting", test_num);
            reset_dut();
            LOAD = 0;
            SER_IN = 1;
            repeat(8) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load priority over Shift", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 8'hCC;
            SER_IN = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hCC, 1'b1);
        end
        endtask

    task testcase008;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift pattern 0xA5 through", test_num);
            reset_dut();
            pattern = 8'hA5;
            LOAD = 0;
            for(i=0; i<8; i=i+1) begin
                SER_IN = pattern[7-i];
                @(posedge CLK);
            end
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_Q;
        input expected_SER_OUT;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_SER_OUT === (expected_SER_OUT ^ SER_OUT ^ expected_SER_OUT)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, SER_OUT=%b",
                         Q, SER_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, SER_OUT=%b",
                         expected_Q, expected_SER_OUT);
                $display("  Got:      Q=%h, SER_OUT=%b",
                         Q, SER_OUT);
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
        $dumpvars(0,CLK, DATA_IN, LOAD, SER_IN, Q, SER_OUT);
    end

endmodule
