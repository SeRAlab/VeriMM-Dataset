`timescale 1ns/1ps

module counter_with_load_reset_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA_IN;
    reg LOAD;
    reg RESET;
    wire [3:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_load_reset dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .RESET(RESET),
        .COUNT(COUNT)
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
            DATA_IN = 4'h0;
            @(posedge CLK);
            #1 RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Input (DATA_IN = 4'hA)", test_num);
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 4'hA;
            @(posedge CLK);
            #1 LOAD = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Increment (3 cycles)", test_num);
            reset_dut();
            repeat(3) @(posedge CLK);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around logic (F -> 0)", test_num);
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 4'hF;
            @(posedge CLK);
            #1 LOAD = 0;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority (RESET should override LOAD)", test_num);
            reset_dut();
            @(negedge CLK);
            RESET = 1;
            LOAD = 1;
            DATA_IN = 4'h5;
            @(posedge CLK);
            #1 RESET = 0; LOAD = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load then increment multiple times", test_num);
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 4'h7;
            @(posedge CLK);
            #1 LOAD = 0;
            repeat(2) @(posedge CLK);
            #1 #1;
 check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_with_load_reset Testbench");
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
        input [3:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, DATA_IN, LOAD, RESET, COUNT);
    end

endmodule
