`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] in;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 5'b00000;
            repeat (5) @(posedge clk);
            $display("DUT Reset: Input cleared and stabilized.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bits stable change", test_num);
            reset_dut();

            in = 5'b11111;
            repeat (3) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 1-cycle noise suppression", test_num);
            reset_dut();

            in = 5'b10101;
            @(posedge clk);
            in = 5'b00000;
            repeat (3) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 2-cycle noise suppression", test_num);
            reset_dut();

            in = 5'b11111;
            repeat (2) @(posedge clk);
            in = 5'b00000;
            repeat (3) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit independence check", test_num);
            reset_dut();


            in = 5'b10001;
            @(posedge clk);


            in = 5'b00001;
            @(posedge clk);


            in = 5'b10001;
            @(posedge clk);

            #1;


            #1;



            check_outputs(5'b00001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive stable transitions", test_num);
            reset_dut();


            in = 5'b01010;
            repeat (3) @(posedge clk);


            in = 5'b10101;
            repeat (3) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid toggle suppression", test_num);
            reset_dut();

            repeat (5) begin
                in = 5'b11111;
                @(posedge clk);
                in = 5'b00000;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
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
        input [4:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
