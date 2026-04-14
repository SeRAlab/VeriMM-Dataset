`timescale 1ns/1ps

module verified_mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in0;
    reg [7:0] data_in1;
    reg sel;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    verified_mux_2to1 dut (
        .data_in0(data_in0),
        .data_in1(data_in1),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select data_in0 (0xAA)", test_num);
        data_in0 = 8'hAA;
        data_in1 = 8'h55;
        sel = 1'b0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select data_in1 (0x55)", test_num);
        data_in0 = 8'hAA;
        data_in1 = 8'h55;
        sel = 1'b1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: All ones on data_in0", test_num);
        data_in0 = 8'hFF;
        data_in1 = 8'h00;
        sel = 1'b0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All zeros on data_in1", test_num);
        data_in0 = 8'hFF;
        data_in1 = 8'h00;
        sel = 1'b1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Dynamic data change on selected input (sel=0)", test_num);
        sel = 1'b0;
        data_in1 = 8'h00;
        data_in0 = 8'h12;
        #5;
        data_in0 = 8'h34;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Dynamic data change on selected input (sel=1)", test_num);
        sel = 1'b1;
        data_in0 = 8'hFF;
        data_in1 = 8'hCC;
        #5;
        data_in1 = 8'hDD;
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Toggle select bit (sel 1 -> 0)", test_num);
        data_in0 = 8'h11;
        data_in1 = 8'h22;
        sel = 1'b1;
        #5;
        sel = 1'b0;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        data_in0 = 8'b10101010;
        data_in1 = 8'b01010101;
        sel = 1'b1;
        #1;

        check_outputs(8'b01010101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("verified_mux_2to1 Testbench");
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
