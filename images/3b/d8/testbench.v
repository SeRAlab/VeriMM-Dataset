`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg enable;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .Vin(Vin),
        .enable(enable),
        .Vout(Vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Voltage check (Vin=0V, Enable=1)", test_num);
            enable = 1;
            Vin = 8'd0;
            #10;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Scale Voltage check (Vin=1V/255, Enable=1)", test_num);
            enable = 1;
            Vin = 8'd255;
            #10;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-scale Voltage check (Vin=0.5V/128, Enable=1)", test_num);
            enable = 1;
            Vin = 8'd128;
            #10;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Latch behavior check (Enable 1 -> 0)", test_num);

            enable = 1;
            Vin = 8'hA5;
            #10;

            enable = 0;
            #5;

            Vin = 8'h5A;
            #10;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Recovery from Latch (Enable 0 -> 1)", test_num);

            enable = 1;
            #10;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Vin changes while disabled", test_num);

            Vin = 8'h12;
            enable = 1;
            #10;

            enable = 0;
            #5;
            Vin = 8'h34; #5;
            Vin = 8'h56; #5;
            Vin = 8'h78; #10;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Enable Toggle", test_num);
            Vin = 8'hCC;
            enable = 1;
            #10;
            enable = 0;
            Vin = 8'hDD;
            #5;
            enable = 1;
            #10;

            #1;


            check_outputs(8'hDD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit Testbench");
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
        input [7:0] expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h",
                         expected_Vout);
                $display("  Got:      Vout=%h",
                         Vout);
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
