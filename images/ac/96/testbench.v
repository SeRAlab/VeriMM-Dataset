`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg flush;
    reg mainClk;
    reg pop_valid;
    reg [7:0] push_payload;
    reg push_valid;
    reg systemReset;
    wire [4:0] availability;
    wire [4:0] occupancy;
    wire [7:0] pop_payload;
    wire pop_ready;
    wire push_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .flush(flush),
        .mainClk(mainClk),
        .pop_valid(pop_valid),
        .push_payload(push_payload),
        .push_valid(push_valid),
        .systemReset(systemReset),
        .availability(availability),
        .occupancy(occupancy),
        .pop_payload(pop_payload),
        .pop_ready(pop_ready),
        .push_ready(push_ready)
    );

    // Clock generation (10ns period)
    initial begin
        mainClk = 0;
        forever #5 mainClk = ~mainClk;
    end

        task reset_dut;

    begin
        systemReset = 1;
        flush = 0;
        push_valid = 0;
        pop_valid = 0;
        push_payload = 8'h00;
        repeat(2) @(posedge mainClk);
        #1;
        systemReset = 0;
        @(posedge mainClk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset State Check");
        reset_dut();


        #1;



        check_outputs(5'd16, 5'd0, pop_payload, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single Push Check");
        reset_dut();
        push_valid = 1;
        push_payload = 8'hA5;
        @(posedge mainClk);
        #1;
        push_valid = 0;

        #1;


        check_outputs(5'd15, 5'd1, 8'hA5, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        $display("Running testcase003: Fill FIFO Check");
        reset_dut();
        for (i = 0; i < 16; i = i + 1) begin
            push_valid = 1;
            push_payload = i[7:0];
            @(posedge mainClk);
            #1;
        end
        push_valid = 0;

        #1;


        check_outputs(5'd0, 5'd16, 8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        $display("Running testcase004: Emptying FIFO Check");
        reset_dut();

        for (i = 0; i < 16; i = i + 1) begin
            push_valid = 1; push_payload = i[7:0];
            @(posedge mainClk); #1;
        end
        push_valid = 0;

        for (i = 0; i < 16; i = i + 1) begin
            pop_valid = 1;
            @(posedge mainClk); #1;
        end
        pop_valid = 0;

        #1;


        check_outputs(5'd16, 5'd0, pop_payload, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Data Ordering Check");
        reset_dut();

        push_valid = 1; push_payload = 8'h11; @(posedge mainClk); #1;
        push_valid = 1; push_payload = 8'h22; @(posedge mainClk); #1;
        push_valid = 1; push_payload = 8'h33; @(posedge mainClk); #1;
        push_valid = 0;


        pop_valid = 1; @(posedge mainClk); #1;
        pop_valid = 0;


        #1;



        check_outputs(5'd14, 5'd2, 8'h22, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Flush Check");
        reset_dut();

        push_valid = 1; push_payload = 8'h66; @(posedge mainClk); #1;
        push_valid = 1; push_payload = 8'h77; @(posedge mainClk); #1;


        flush = 1;
        @(posedge mainClk);
        #1;
        flush = 0;


        #1;



        check_outputs(5'd16, 5'd0, pop_payload, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Simultaneous Push/Pop Check");
        reset_dut();

        push_valid = 1; push_payload = 8'hAA; @(posedge mainClk); #1;
        push_valid = 0;


        push_valid = 1; push_payload = 8'hBB;
        pop_valid = 1;
        @(posedge mainClk);
        #1;
        push_valid = 0;
        pop_valid = 0;


        #1;



        check_outputs(5'd15, 5'd1, 8'hBB, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    integer i;
    begin
        $display("Running testcase008: Overflow Protection Check");
        reset_dut();

        for (i = 0; i < 16; i = i + 1) begin
            push_valid = 1; push_payload = i[7:0];
            @(posedge mainClk); #1;
        end


        push_valid = 1; push_payload = 8'hFF;
        @(posedge mainClk); #1;
        push_valid = 0;


        #1;



        check_outputs(5'd0, 5'd16, 8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Running testcase009: Underflow Protection Check");
        reset_dut();

        pop_valid = 1;
        @(posedge mainClk); #1;
        pop_valid = 0;


        #1;



        check_outputs(5'd16, 5'd0, pop_payload, 1'b0, 1'b1);
    end
        endtask

    task testcase010;

    integer i;
    begin
        $display("Running testcase010: Wrap-around Logic Check");
        reset_dut();

        for (i = 0; i < 10; i = i + 1) begin
            push_valid = 1; push_payload = i[7:0]; @(posedge mainClk); #1;
        end

        for (i = 0; i < 5; i = i + 1) begin
            pop_valid = 1; @(posedge mainClk); #1;
        end
        pop_valid = 0; push_valid = 0;

        for (i = 0; i < 10; i = i + 1) begin
            push_valid = 1; push_payload = 8'hCC; @(posedge mainClk); #1;
        end
        push_valid = 0;



        #1;




        check_outputs(5'd1, 5'd15, 8'h05, 1'b1, 1'b1);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [4:0] expected_availability;
        input [4:0] expected_occupancy;
        input [7:0] expected_pop_payload;
        input expected_pop_ready;
        input expected_push_ready;
        begin
            if (expected_availability === (expected_availability ^ availability ^ expected_availability) &&
                expected_occupancy === (expected_occupancy ^ occupancy ^ expected_occupancy) &&
                expected_pop_payload === (expected_pop_payload ^ pop_payload ^ expected_pop_payload) &&
                expected_pop_ready === (expected_pop_ready ^ pop_ready ^ expected_pop_ready) &&
                expected_push_ready === (expected_push_ready ^ push_ready ^ expected_push_ready)) begin
                $display("PASS");
                $display("  Outputs: availability=%h, occupancy=%h, pop_payload=%h, pop_ready=%b, push_ready=%b",
                         availability, occupancy, pop_payload, pop_ready, push_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: availability=%h, occupancy=%h, pop_payload=%h, pop_ready=%b, push_ready=%b",
                         expected_availability, expected_occupancy, expected_pop_payload, expected_pop_ready, expected_push_ready);
                $display("  Got:      availability=%h, occupancy=%h, pop_payload=%h, pop_ready=%b, push_ready=%b",
                         availability, occupancy, pop_payload, pop_ready, push_ready);
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
        $dumpvars(0,flush, mainClk, pop_valid, push_payload, push_valid, systemReset, availability, occupancy, pop_payload, pop_ready, push_ready);
    end

endmodule
