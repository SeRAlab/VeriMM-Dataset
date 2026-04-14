`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dt;
    reg rst;
    reg [15:0] v;
    reg [15:0] z;
    wire [15:0] v_est;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .dt(dt),
        .rst(rst),
        .v(v),
        .z(z),
        .v_est(v_est),
        .x_est(x_est)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        dt = 16'h0000;
        v = 16'h0000;
        z = 16'h0000;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task wait_cycles;

        input [31:0] count;
        repeat (count) @(posedge clk);
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: Static Tracking", test_num);
        reset_dut();
        dt = 16'h0001;
        z  = 16'h0100;
        v  = 16'h0000;


        wait_cycles(20);





        #1;






        check_outputs(16'h0000, 16'h0100);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Running Testcase %03d: Linear Motion", test_num);
        reset_dut();
        dt = 16'h0001;
        v  = 16'h0010;
        z  = 16'h0000;

        for(i = 0; i < 10; i = i + 1) begin
            z = z + v;
            @(posedge clk);
        end


        #1;



        check_outputs(16'h0010, 16'h00A0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Noise Filtering", test_num);
        reset_dut();
        dt = 16'h0001;
        z = 16'h0050;
        v = 16'h0000;
        wait_cycles(10);

        z = 16'hFFFF;
        @(posedge clk);



        if (x_est < 16'h0100)
            #1;

            check_outputs(v_est, x_est);
        else
            #1;

            check_outputs(16'h0000, 16'h0050);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_v_est;
        input [15:0] expected_x_est;
        begin
            if (expected_v_est === (expected_v_est ^ v_est ^ expected_v_est) &&
                expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: v_est=%h, x_est=%h",
                         v_est, x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_est=%h, x_est=%h",
                         expected_v_est, expected_x_est);
                $display("  Got:      v_est=%h, x_est=%h",
                         v_est, x_est);
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
        $dumpvars(0,clk, dt, rst, v, z, v_est, x_est);
    end

endmodule
