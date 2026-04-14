`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] b1_strobe;
    reg [7:0] b2_strobe;
    reg clk;
    reg [1:0] no_bunches;
    reg [3:0] no_samples;
    reg [7:0] sample_spacing;
    reg store_strb;
    wire LUTcond;
    wire bunch_strb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b1_strobe(b1_strobe),
        .b2_strobe(b2_strobe),
        .clk(clk),
        .no_bunches(no_bunches),
        .no_samples(no_samples),
        .sample_spacing(sample_spacing),
        .store_strb(store_strb),
        .LUTcond(LUTcond),
        .bunch_strb(bunch_strb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            b1_strobe = 8'h00;
            b2_strobe = 8'h00;
            no_bunches = 2'b00;
            no_samples = 4'h0;
            sample_spacing = 8'h00;
            store_strb = 0;

            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 1 Bunch, 4 Samples", test_num);
            reset_dut();


            no_bunches = 2'd1;
            no_samples = 4'd4;
            sample_spacing = 8'd1;
            b1_strobe = 8'd1;
            b2_strobe = 8'd4;

            @(posedge clk);


            repeat (4) begin
                store_strb = 1;
                @(posedge clk);
                store_strb = 0;
                repeat (2) @(posedge clk);
            end



            #1;




            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 2 Bunches, 2 Samples Each", test_num);
            reset_dut();

            no_bunches = 2'd2;
            no_samples = 4'd2;
            sample_spacing = 8'd5;
            b1_strobe = 8'd0;
            b2_strobe = 8'd10;

            @(posedge clk);


            repeat (2) begin
                store_strb = 1;
                @(posedge clk);
                store_strb = 0;
                repeat (1) @(posedge clk);
            end


            repeat (2) begin
                store_strb = 1;
                @(posedge clk);
                store_strb = 0;
                repeat (1) @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking Strobe Bounds", test_num);
            reset_dut();

            no_bunches = 2'd1;
            no_samples = 4'd8;
            sample_spacing = 8'd2;
            b1_strobe = 8'd2;
            b2_strobe = 8'd6;

            @(posedge clk);


            repeat (10) begin
                store_strb = 1;
                @(posedge clk);
                store_strb = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Max Configuration", test_num);
            reset_dut();

            no_bunches = 2'b11;
            no_samples = 4'hf;
            sample_spacing = 8'hFF;

            @(posedge clk);
            store_strb = 1;
            @(posedge clk);
            store_strb = 0;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Fast Store Pulses", test_num);
            reset_dut();

            no_bunches = 2'd1;
            no_samples = 4'd5;

            @(posedge clk);

            store_strb = 1;
            repeat(5) @(posedge clk);
            store_strb = 0;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_LUTcond;
        input expected_bunch_strb;
        begin
            if (expected_LUTcond === (expected_LUTcond ^ LUTcond ^ expected_LUTcond) &&
                expected_bunch_strb === (expected_bunch_strb ^ bunch_strb ^ expected_bunch_strb)) begin
                $display("PASS");
                $display("  Outputs: LUTcond=%b, bunch_strb=%b",
                         LUTcond, bunch_strb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LUTcond=%b, bunch_strb=%b",
                         expected_LUTcond, expected_bunch_strb);
                $display("  Got:      LUTcond=%b, bunch_strb=%b",
                         LUTcond, bunch_strb);
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
        $dumpvars(0,b1_strobe, b2_strobe, clk, no_bunches, no_samples, sample_spacing, store_strb, LUTcond, bunch_strb);
    end

endmodule
