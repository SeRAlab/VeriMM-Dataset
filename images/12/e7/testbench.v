`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] K;
    reg [31:0] S;
    reg [31:0] T;
    reg [31:0] r;
    reg [31:0] sigma;
    wire [31:0] call_price;
    wire [31:0] put_price;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    black_scholes dut (
        .K(K),
        .S(S),
        .T(T),
        .r(r),
        .sigma(sigma),
        .call_price(call_price),
        .put_price(put_price)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: At-the-money (ATM)", test_num);
            S     = 32'h00640000;
            K     = 32'h00640000;
            T     = 32'h00010000;
            r     = 32'h00000CCD;
            sigma = 32'h00003333;
            #1;

            check_outputs(32'h000A7359, 32'h000592D6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: In-the-money (ITM) Call", test_num);
            S     = 32'h00780000;
            K     = 32'h00640000;
            T     = 32'h00010000;
            r     = 32'h00000CCD;
            sigma = 32'h00003333;
            #1;

            check_outputs(32'h001A0A3D, 32'h000247AE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Out-of-the-money (OTM) Call", test_num);
            S     = 32'h00500000;
            K     = 32'h00640000;
            T     = 32'h00010000;
            r     = 32'h00000CCD;
            sigma = 32'h00003333;
            #1;

            check_outputs(32'h0001DB22, 32'h0010FA3D);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Low Volatility, Short Duration", test_num);
            S     = 32'h00640000;
            K     = 32'h00640000;
            T     = 32'h00008000;
            r     = 32'h0000051F;
            sigma = 32'h00001999;
            #1;

            check_outputs(32'h00018000, 32'h0000828F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Interest Rate", test_num);
            S     = 32'h00640000;
            K     = 32'h00640000;
            T     = 32'h00010000;
            r     = 32'h00000000;
            sigma = 32'h00003333;
            #1;

            check_outputs(32'h0007F851, 32'h0007F851);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("black_scholes Testbench");
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
        input [31:0] expected_call_price;
        input [31:0] expected_put_price;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_call_price === (expected_call_price ^ call_price ^ expected_call_price) &&
                expected_put_price === (expected_put_price ^ put_price ^ expected_put_price)) begin
                $display("PASS");
                $display("  Outputs: call_price=%h, put_price=%h",
                         call_price, put_price);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: call_price=%h, put_price=%h",
                         expected_call_price, expected_put_price);
                $display("  Got:      call_price=%h, put_price=%h",
                         call_price, put_price);
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

endmodule
