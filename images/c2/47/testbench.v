`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LOAD;
    reg [7:0] LOAD_DATA;
    reg RESET;
    wire [7:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .CLK(CLK),
        .LOAD(LOAD),
        .LOAD_DATA(LOAD_DATA),
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
            RESET = 1;
            LOAD = 0;
            LOAD_DATA = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Incrementing (10 cycles)", test_num);
            reset_dut();

            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Parallel Load (Load 0x55)", test_num);
            reset_dut();
            LOAD = 1;
            LOAD_DATA = 8'h55;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0x20 and increment 5 times", test_num);
            reset_dut();

            LOAD = 1;
            LOAD_DATA = 8'h20;
            @(posedge CLK);
            #1;
            LOAD = 0;

            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter Rollover", test_num);
            reset_dut();

            LOAD = 1;
            LOAD_DATA = 8'hFE;
            @(posedge CLK);
            #1;
            LOAD = 0;

            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority over Load", test_num);
            reset_dut();

            RESET = 1;
            LOAD = 1;
            LOAD_DATA = 8'hAA;
            @(posedge CLK);
            #1;
            RESET = 0;
            LOAD = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load Priority over Increment", test_num);
            reset_dut();

            repeat(3) @(posedge CLK);
            #1;

            LOAD = 1;
            LOAD_DATA = 8'hCC;
            @(posedge CLK);
            #1;
            LOAD = 0;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [7:0] expected_COUNT;
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
        $dumpvars(0,CLK, LOAD, LOAD_DATA, RESET, COUNT);
    end

endmodule
