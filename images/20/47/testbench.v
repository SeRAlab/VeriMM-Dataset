`timescale 1ns/1ps

module PIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg load;
    reg oe;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PIPO_Shift_Register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .oe(oe),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load = 0;
            oe = 0;
            data_in = 5'b0;
            @(posedge clk);
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Load and Output Enable", test_num);
            reset_dut();


            data_in = 5'b10101;
            load = 1;
            @(posedge clk);


            #1;
            load = 0;
            oe = 1;
            #2;

            #1;


            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Output Disable (High-Z) Check", test_num);
            reset_dut();


            data_in = 5'b11111;
            load = 1;
            @(posedge clk);


            #1;
            load = 0;
            oe = 0;
            #2;

            #1;


            check_outputs(5'bzzzzz);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Retention when load=0", test_num);
            reset_dut();


            data_in = 5'h0A;
            load = 1;
            @(posedge clk);


            #1;
            data_in = 5'h1F;
            load = 0;
            @(posedge clk);


            #1;
            oe = 1;
            #2;

            #1;


            check_outputs(5'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Bus High (0x1F)", test_num);
            reset_dut();

            data_in = 5'b11111;
            load = 1;
            @(posedge clk);

            #1;
            load = 0;
            oe = 1;
            #2;

            #1;


            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggling OE", test_num);
            reset_dut();


            data_in = 5'h12;
            load = 1;
            @(posedge clk);

            #1;
            load = 0;
            oe = 1;
            #2;
            $display("Checking OE=1...");
            if (data_out !== 5'h12) $display("Sub-test failed: OE=1 didn't show data");

            oe = 0;
            #2;
            $display("Checking OE=0...");
            if (data_out !== 5'bz) $display("Sub-test failed: OE=0 didn't go High-Z");

            oe = 1;
            #2;
            #1;

            check_outputs(5'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PIPO_Shift_Register Testbench");
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
        input [4:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, oe, data_out);
    end

endmodule
