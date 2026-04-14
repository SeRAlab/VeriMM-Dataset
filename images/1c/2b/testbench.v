`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data;
    reg we;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data(data),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        we = 0;
        forever #5 we = ~we;
    end

        task reset_dut;

    begin
        data = 4'b0000;


        #20;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nTestcase %0d: Writing 4'h5 to SRAM", test_num);
        data = 4'h5;
        #20;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nTestcase %0d: Writing 4'hA to SRAM", test_num);
        data = 4'hA;
        #20;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nTestcase %0d: Writing 4'hF to SRAM", test_num);
        data = 4'hF;
        #20;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin

        data = 4'hF;
        #20;

        test_num = 4;
        $display("\nTestcase %0d: Writing 4'h0 to SRAM", test_num);
        data = 4'h0;
        #20;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nTestcase %0d: Checking Hold Functionality", test_num);


        data = 4'hC;
        #20;





        data = 4'h3;



        #1;




        check_outputs(4'hC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,data, we, q);
    end

endmodule
