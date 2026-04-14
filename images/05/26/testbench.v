`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg rw;
    wire [7:0] data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .rw(rw),
        .data_out(data_out),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        rw = 0;
        data_in = 8'h00;
        @(posedge clk);
        #1 rst = 0;

        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Reset and IDLE state...", test_num);
        reset_dut();


        #1;



        check_outputs(8'h00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying transition to WRITE state...", test_num);
        reset_dut();


        rw = 1;
        data_in = 8'hAA;
        @(posedge clk);
        #1;


        #1;



        check_outputs(data_out, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying transition to READ state...", test_num);
        reset_dut();


        rw = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(data_out, 2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying Write-to-Read transition and data integrity...", test_num);
        reset_dut();


        rw = 1;
        data_in = 8'h55;
        @(posedge clk);
        #1;


        rw = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'h55, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying WRITE state with specific data pattern...", test_num);
        reset_dut();

        rw = 1;
        data_in = 8'hFF;
        @(posedge clk);
        #1;


        rw = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hFF, 2'b01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input [7:0] expected_data_out;
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state=%h",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state=%h",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%h, state=%h",
                         data_out, state);
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
        $dumpvars(0,clk, data_in, rst, rw, data_out, state);
    end

endmodule
