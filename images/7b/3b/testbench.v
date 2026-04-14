`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg io_flush;
    reg io_mainClk;
    reg io_pop_ready;
    reg io_push_payload_error;
    reg [31:0] io_push_payload_inst;
    reg io_push_valid;
    reg resetCtrl_systemReset;
    wire io_occupancy;
    wire io_pop_payload_error;
    wire [31:0] io_pop_payload_inst;
    wire io_pop_valid;
    wire io_push_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_flush(io_flush),
        .io_mainClk(io_mainClk),
        .io_pop_ready(io_pop_ready),
        .io_push_payload_error(io_push_payload_error),
        .io_push_payload_inst(io_push_payload_inst),
        .io_push_valid(io_push_valid),
        .resetCtrl_systemReset(resetCtrl_systemReset),
        .io_occupancy(io_occupancy),
        .io_pop_payload_error(io_pop_payload_error),
        .io_pop_payload_inst(io_pop_payload_inst),
        .io_pop_valid(io_pop_valid),
        .io_push_ready(io_push_ready)
    );

    // Clock generation (10ns period)
    initial begin
        io_mainClk = 0;
        forever #5 io_mainClk = ~io_mainClk;
    end

        task reset_dut;

        begin
            resetCtrl_systemReset = 1;
            io_flush = 0;
            io_push_valid = 0;
            io_push_payload_error = 0;
            io_push_payload_inst = 0;
            io_pop_ready = 0;
            repeat (2) @(posedge io_mainClk);
            resetCtrl_systemReset = 0;
            @(posedge io_mainClk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge io_mainClk);
            io_push_valid = 1;
            io_push_payload_inst = 32'hA5A5A5A5;
            io_push_payload_error = 0;
            @(posedge io_mainClk);
            io_push_valid = 0;



            #1;




            check_outputs(1'b1, 1'b0, 32'hA5A5A5A5, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge io_mainClk);
            io_push_valid = 1;
            io_push_payload_inst = 32'hEEEEEEEE;
            io_push_payload_error = 1;
            @(posedge io_mainClk);
            io_push_valid = 0;


            #1;



            check_outputs(1'b1, 1'b1, 32'hEEEEEEEE, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            io_push_valid = 1;
            io_push_payload_inst = 32'h12345678;
            @(posedge io_mainClk);
            io_push_valid = 0;


            io_pop_ready = 1;
            @(posedge io_mainClk);
            io_pop_ready = 0;



            #1;




            check_outputs(1'b0, 1'bx, 32'hxxxxxxxx, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            io_push_valid = 1;
            for (i = 0; i < 128; i = i + 1) begin
                io_push_payload_inst = i;
                @(posedge io_mainClk);
                while (!io_push_ready) @(posedge io_mainClk);
            end
            io_push_valid = 0;



            #1;




            check_outputs(1'b1, 1'b0, 32'h00000000, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            io_push_valid = 1;
            io_push_payload_inst = 32'hCAFEF00D;
            repeat(5) @(posedge io_mainClk);
            io_push_valid = 0;


            io_flush = 1;
            @(posedge io_mainClk);
            io_flush = 0;
            @(posedge io_mainClk);


            #1;



            check_outputs(1'b0, 1'b0, 32'hxxxxxxxx, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            io_push_valid = 1;
            io_push_payload_inst = 32'h11111111;
            @(posedge io_mainClk);

            io_push_payload_inst = 32'h22222222;
            @(posedge io_mainClk);
            io_push_valid = 0;


            io_pop_ready = 1;
            @(posedge io_mainClk);


            #1;



            check_outputs(1'b1, 1'b0, 32'h22222222, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            reset_dut();

            io_push_valid = 1;
            for (i = 0; i < 128; i = i + 1) begin
                io_push_payload_inst = i;
                @(posedge io_mainClk);
            end


            io_push_valid = 1;
            io_push_payload_inst = 32'hFFFFFFFF;
            io_pop_ready = 1;
            @(posedge io_mainClk);
            io_push_valid = 0;
            io_pop_ready = 0;



            #1;




            check_outputs(1'b1, 1'b0, 32'h00000001, 1'b1, 1'b0);
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
        input expected_io_occupancy;
        input expected_io_pop_payload_error;
        input [31:0] expected_io_pop_payload_inst;
        input expected_io_pop_valid;
        input expected_io_push_ready;
        begin
            if (expected_io_occupancy === (expected_io_occupancy ^ io_occupancy ^ expected_io_occupancy) &&
                expected_io_pop_payload_error === (expected_io_pop_payload_error ^ io_pop_payload_error ^ expected_io_pop_payload_error) &&
                expected_io_pop_payload_inst === (expected_io_pop_payload_inst ^ io_pop_payload_inst ^ expected_io_pop_payload_inst) &&
                expected_io_pop_valid === (expected_io_pop_valid ^ io_pop_valid ^ expected_io_pop_valid) &&
                expected_io_push_ready === (expected_io_push_ready ^ io_push_ready ^ expected_io_push_ready)) begin
                $display("PASS");
                $display("  Outputs: io_occupancy=%b, io_pop_payload_error=%b, io_pop_payload_inst=%h, io_pop_valid=%b, io_push_ready=%b",
                         io_occupancy, io_pop_payload_error, io_pop_payload_inst, io_pop_valid, io_push_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_occupancy=%b, io_pop_payload_error=%b, io_pop_payload_inst=%h, io_pop_valid=%b, io_push_ready=%b",
                         expected_io_occupancy, expected_io_pop_payload_error, expected_io_pop_payload_inst, expected_io_pop_valid, expected_io_push_ready);
                $display("  Got:      io_occupancy=%b, io_pop_payload_error=%b, io_pop_payload_inst=%h, io_pop_valid=%b, io_push_ready=%b",
                         io_occupancy, io_pop_payload_error, io_pop_payload_inst, io_pop_valid, io_push_ready);
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
        $dumpvars(0,io_flush, io_mainClk, io_pop_ready, io_push_payload_error, io_push_payload_inst, io_push_valid, resetCtrl_systemReset, io_occupancy, io_pop_payload_error, io_pop_payload_inst, io_pop_valid, io_push_ready);
    end

endmodule
