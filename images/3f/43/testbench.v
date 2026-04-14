`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg re;
    reg reset;
    reg we;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .clk(clk),
        .data_in(data_in),
        .re(re),
        .reset(reset),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        we = 0;
        re = 0;
        data_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Read after Reset", test_num);
        reset_dut();
        re = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Write 1, Read 1", test_num);
        reset_dut();


        data_in = 1;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        re = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overwrite check (1 then 0)", test_num);
        reset_dut();


        data_in = 1; we = 1;
        @(posedge clk);
        #1


        data_in = 0; we = 1;
        @(posedge clk);
        #1 we = 0;


        re = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Write Enable check (WE=0)", test_num);
        reset_dut();

        data_in = 1;
        we = 0;
        @(posedge clk);
        #1

        re = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Read Enable check (RE=0)", test_num);
        reset_dut();

        data_in = 1;
        we = 1;
        @(posedge clk);
        #1 we = 0;

        re = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset priority over Write", test_num);
        reset_dut();

        data_in = 1;
        we = 1;
        reset = 1;
        @(posedge clk);
        #1 reset = 0; we = 0;

        re = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
        $dumpvars(0,clk, data_in, re, reset, we, data_out);
    end

endmodule
