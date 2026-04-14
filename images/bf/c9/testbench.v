`timescale 1ns/1ps

module register5_wl_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [4:0] datain;
    reg load;
    wire [4:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register5_wl dut (
        .clock(clock),
        .datain(datain),
        .load(load),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            load = 0;
            datain = 5'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Load 5'h15", test_num);
            reset_dut();
            @(negedge clock);
            datain = 5'h15;
            load = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load 5'h0A", test_num);
            reset_dut();
            @(negedge clock);
            datain = 5'h0A;
            load = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Clear register by deasserting load", test_num);
            reset_dut();

            @(negedge clock);
            datain = 5'h1F;
            load = 1;
            @(posedge clock);

            @(negedge clock);
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Load 5'h1F (All ones)", test_num);
            reset_dut();
            @(negedge clock);
            datain = 5'h1F;
            load = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Data ignored when load is low", test_num);
            reset_dut();
            @(negedge clock);
            datain = 5'h12;
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Consecutive loads", test_num);
            reset_dut();

            @(negedge clock);
            datain = 5'h05;
            load = 1;
            @(posedge clock);

            @(negedge clock);
            datain = 5'h10;
            load = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register5_wl Testbench");
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
        input [4:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,clock, datain, load, dataout);
    end

endmodule
