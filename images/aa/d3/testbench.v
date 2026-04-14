`timescale 1ns/1ps

module mux4to1_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [1:0] sel;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1_8bit dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Data 0", test_num);
            data0 = 8'hAA;
            data1 = 8'hBB;
            data2 = 8'hCC;
            data3 = 8'hDD;
            sel   = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Data 1", test_num);
            data0 = 8'h11;
            data1 = 8'h22;
            data2 = 8'h33;
            data3 = 8'h44;
            sel   = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Data 2", test_num);
            data0 = 8'h0F;
            data1 = 8'hF0;
            data2 = 8'hA5;
            data3 = 8'h5A;
            sel   = 2'b10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Data 3", test_num);
            data0 = 8'h00;
            data1 = 8'hFF;
            data2 = 8'h55;
            data3 = 8'hAA;
            sel   = 2'b11;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Inputs Same (Value 0x77)", test_num);
            data0 = 8'h77;
            data1 = 8'h77;
            data2 = 8'h77;
            data3 = 8'h77;
            sel   = 2'b01;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Boundary Check", test_num);
            data0 = 8'h00;
            data1 = 8'h00;
            data2 = 8'h00;
            data3 = 8'h00;
            sel   = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Scale Check (0xFF)", test_num);
            data0 = 8'hFF;
            data1 = 8'hFF;
            data2 = 8'hFF;
            data3 = 8'hFF;
            sel   = 2'b11;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1_8bit Testbench");
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
