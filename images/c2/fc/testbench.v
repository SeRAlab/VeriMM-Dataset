`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire [8:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition 15 + 32 = 47", test_num);
            reset_dut();
            A = 8'd15;
            B = 8'd32;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd47);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Addition 127 + 128 = 255", test_num);
            reset_dut();
            A = 8'd127;
            B = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Check 255 + 1 = 256", test_num);
            reset_dut();
            A = 8'd255;
            B = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd256);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Sum 255 + 255 = 510", test_num);
            reset_dut();
            A = 8'd255;
            B = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition 0 + 0 = 0", test_num);
            reset_dut();
            A = 8'd0;
            B = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Pattern Check 0xAA + 0x55 = 0xFF", test_num);
            reset_dut();
            A = 8'hAA;
            B = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h0FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Bit C[8] Verification 128 + 128 = 256", test_num);
            reset_dut();
            A = 8'd128;
            B = 8'd128;
            @(posedge clk);
            #1;
            if (C[8] === 1'b1)
                $display("  Carry bit C[8] is correctly set.");
            else
                $display("  Carry bit C[8] is NOT set!");
            #1;

            check_outputs(9'd256);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [8:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, rst, C);
    end

endmodule
