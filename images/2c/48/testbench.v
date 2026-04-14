`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [1:0] select;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .select(select),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input 0 (data0)", test_num);
            data0 = 8'hA5;
            data1 = 8'h00;
            data2 = 8'h00;
            data3 = 8'h00;
            select = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input 1 (data1)", test_num);
            data0 = 8'h00;
            data1 = 8'h5A;
            data2 = 8'h00;
            data3 = 8'h00;
            select = 2'b01;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input 2 (data2)", test_num);
            data0 = 8'h00;
            data1 = 8'h00;
            data2 = 8'hFF;
            data3 = 8'h00;
            select = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input 3 (data3)", test_num);
            data0 = 8'h00;
            data1 = 8'h00;
            data2 = 8'h00;
            data3 = 8'h12;
            select = 2'b11;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data0 with all inputs populated", test_num);
            data0 = 8'h11;
            data1 = 22;
            data2 = 33;
            data3 = 44;
            select = 2'b00;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data1 with all inputs populated", test_num);
            data0 = 8'h11;
            data1 = 8'h22;
            data2 = 8'h33;
            data3 = 8'h44;
            select = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data2 with all inputs populated", test_num);
            data0 = 8'h11;
            data1 = 8'h22;
            data2 = 8'h33;
            data3 = 8'h44;
            select = 2'b10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data3 with all inputs populated", test_num);
            data0 = 8'h11;
            data1 = 8'h22;
            data2 = 8'h33;
            data3 = 8'h44;
            select = 2'b11;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            data0 = 8'h00;
            data1 = 8'h00;
            data2 = 8'h00;
            data3 = 8'h00;
            select = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs high (0xFF)", test_num);
            data0 = 8'hFF;
            data1 = 8'hFF;
            data2 = 8'hFF;
            data3 = 8'hFF;
            select = 2'b01;
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
        $display("mux4to1 Testbench");
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
        input [7:0] expected_output_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
