`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] read_reg1;
    reg [2:0] read_reg2;
    reg [7:0] write_data;
    reg write_enable;
    reg [2:0] write_reg;
    wire [7:0] forwarded_data1;
    wire [7:0] forwarded_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_data(write_data),
        .write_enable(write_enable),
        .write_reg(write_reg),
        .forwarded_data1(forwarded_data1),
        .forwarded_data2(forwarded_data2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Forwarding to read_reg1", test_num);

            read_reg1 = 3'd1;
            read_reg2 = 3'd2;
            write_reg = 3'd1;
            write_data = 8'hA5;
            write_enable = 1'b1;


            #1;



            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Forwarding to read_reg2", test_num);

            read_reg1 = 3'd1;
            read_reg2 = 3'd2;
            write_reg = 3'd2;
            write_data = 8'h5A;
            write_enable = 1'b1;


            #1;



            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Forwarding to both registers", test_num);

            read_reg1 = 3'd3;
            read_reg2 = 3'd3;
            write_reg = 3'd3;
            write_data = 8'hFF;
            write_enable = 1'b1;


            #1;



            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No forwarding when write_enable is low", test_num);

            read_reg1 = 3'd1;
            read_reg2 = 3'd1;
            write_reg = 3'd1;
            write_data = 8'hEE;
            write_enable = 1'b0;


            #1;



            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No match scenario", test_num);

            read_reg1 = 3'd2;
            read_reg2 = 3'd3;
            write_reg = 3'd1;
            write_data = 8'h77;
            write_enable = 1'b1;


            #1;



            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register 0 check", test_num);

            read_reg1 = 3'd0;
            read_reg2 = 3'd0;
            write_reg = 3'd0;
            write_data = 8'h12;
            write_enable = 1'b1;


            #1;



            check_outputs(8'h12, 8'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [7:0] expected_forwarded_data1;
        input [7:0] expected_forwarded_data2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwarded_data1 === (expected_forwarded_data1 ^ forwarded_data1 ^ expected_forwarded_data1) &&
                expected_forwarded_data2 === (expected_forwarded_data2 ^ forwarded_data2 ^ expected_forwarded_data2)) begin
                $display("PASS");
                $display("  Outputs: forwarded_data1=%h, forwarded_data2=%h",
                         forwarded_data1, forwarded_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwarded_data1=%h, forwarded_data2=%h",
                         expected_forwarded_data1, expected_forwarded_data2);
                $display("  Got:      forwarded_data1=%h, forwarded_data2=%h",
                         forwarded_data1, forwarded_data2);
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
