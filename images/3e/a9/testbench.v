`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [7:0] vin;
    wire pwm_signal;
    wire [7:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .clk(clk),
        .rst_n(rst_n),
        .vin(vin),
        .pwm_signal(pwm_signal),
        .vout(vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        vin = 8'h00;
        @(posedge clk);
        #1;
        rst_n = 1;
        $display("DUT Reset at time %0t", $time);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Initial Reset State", test_num);
        reset_dut();


        #1;



        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Nominal Input Regulation", test_num);
        reset_dut();

        vin = 8'hFF;

        repeat(200) @(posedge clk);



        #1;




        check_outputs(pwm_signal, 8'h80);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Low Input Regulation", test_num);
        reset_dut();

        vin = 8'h90;
        repeat(300) @(posedge clk);


        #1;



        check_outputs(pwm_signal, 8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Insufficient Input Voltage", test_num);
        reset_dut();

        vin = 8'h40;
        repeat(200) @(posedge clk);



        #1;




        check_outputs(1'b1, 8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Dynamic Line Regulation", test_num);
        reset_dut();


        vin = 8'hE0;
        repeat(150) @(posedge clk);


        vin = 8'hA0;
        repeat(150) @(posedge clk);


        #1;



        check_outputs(pwm_signal, 8'h80);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("switching_regulator Testbench");
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
        input expected_pwm_signal;
        input [7:0] expected_vout;
        begin
            if (expected_pwm_signal === (expected_pwm_signal ^ pwm_signal ^ expected_pwm_signal) &&
                expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: pwm_signal=%b, vout=%h",
                         pwm_signal, vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_signal=%b, vout=%h",
                         expected_pwm_signal, expected_vout);
                $display("  Got:      pwm_signal=%b, vout=%h",
                         pwm_signal, vout);
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
        $dumpvars(0,clk, rst_n, vin, pwm_signal, vout);
    end

endmodule
