`timescale 1ns/1ps

module SRAM_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ADDR;
    reg CLK;
    reg [15:0] DATA_IN;
    reg WE;
    wire [15:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_16bit dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .WE(WE),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE = 0;
            ADDR = 0;
            DATA_IN = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write and Read at Address 0", test_num);
            reset_dut();


            @(posedge CLK);
            ADDR = 4'h0;
            DATA_IN = 16'hABCD;
            WE = 1;


            @(posedge CLK);
            WE = 0;
            ADDR = 4'h0;


            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write and Read at Max Address (15)", test_num);
            reset_dut();


            @(posedge CLK);
            ADDR = 4'hF;
            DATA_IN = 16'hFFFF;
            WE = 1;


            @(posedge CLK);
            WE = 0;
            ADDR = 4'hF;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sequential access to different addresses", test_num);
            reset_dut();


            @(posedge CLK);
            ADDR = 4'h1; DATA_IN = 16'h1111; WE = 1;

            @(posedge CLK);
            ADDR = 4'h2; DATA_IN = 16'h2222; WE = 1;


            @(posedge CLK);
            WE = 0; ADDR = 4'h1;
            @(posedge CLK);
            #1;


            WE = 0; ADDR = 4'h2;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overwrite existing data", test_num);
            reset_dut();


            @(posedge CLK);
            ADDR = 4'h5; DATA_IN = 16'hAAAA; WE = 1;


            @(posedge CLK);
            ADDR = 4'h5; DATA_IN = 16'h5555; WE = 1;


            @(posedge CLK);
            WE = 0; ADDR = 4'h5;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: WE low prevents writing", test_num);
            reset_dut();


            @(posedge CLK);
            ADDR = 4'hA; DATA_IN = 16'h1234; WE = 1;


            @(posedge CLK);
            ADDR = 4'hA; DATA_IN = 16'hDANGER; WE = 0;


            @(posedge CLK);
            ADDR = 4'hA; WE = 0;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_16bit Testbench");
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
        input [15:0] expected_DATA_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
        $dumpvars(0,ADDR, CLK, DATA_IN, WE, DATA_OUT);
    end

endmodule
