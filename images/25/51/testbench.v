`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg clk;
    reg reset;
    reg [15:0] x;
    wire [15:0] b;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .a(a),
        .clk(clk),
        .reset(reset),
        .x(x),
        .b(b),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 16'h0000;
            a = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Impulse Response", test_num);
            reset_dut();

            x = 16'h00A0;
            a = 16'h00B0;
            @(posedge clk);

            x = 16'h0000;
            a = 16'h0000;
            @(posedge clk);



            #1;




            check_outputs(16'h00B0, 16'h00A0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Step Response (3 cycles)", test_num);
            reset_dut();

            x = 16'h0010;
            a = 16'h0010;
            repeat(3) @(posedge clk);




            if (y !== 16'h0000 && b !== 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter responded to step input. y=%h, b=%h", y, b);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter output remained zero during step input.");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Feedback Memory Test", test_num);
            reset_dut();

            x = 16'h0F00;
            a = 16'h0F00;
            @(posedge clk);

            x = 16'h0000;
            a = 16'h0000;
            @(posedge clk);


            if (y !== 16'h0000 || b !== 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: History/Feedback detected. y=%h, b=%h", y, b);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter has no memory (acting like combinational logic).");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
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
        input [15:0] expected_b;
        input [15:0] expected_y;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: b=%h, y=%h",
                         b, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, y=%h",
                         expected_b, expected_y);
                $display("  Got:      b=%h, y=%h",
                         b, y);
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
        $dumpvars(0,a, clk, reset, x, b, y);
    end

endmodule
