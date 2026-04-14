`timescale 1ns/1ps

module data_bus_mux_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in0;
    reg [31:0] data_in1;
    reg [31:0] data_in2;
    reg [31:0] data_in3;
    reg [1:0] select;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_bus_mux dut (
        .data_in0(data_in0),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_in3(data_in3),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select data_in0", test_num);
        data_in0 = 32'hDEADBEEF;
        data_in1 = 32'h00000000;
        data_in2 = 32'hFFFFFFFF;
        data_in3 = 32'h12345678;
        select = 2'b00;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select data_in1", test_num);
        data_in0 = 32'h00000000;
        data_in1 = 32'hCAFEBABE;
        data_in2 = 32'h55555555;
        data_in3 = 32'hAAAAAAAA;
        select = 2'b01;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select data_in2", test_num);
        data_in0 = 32'h11111111;
        data_in1 = 32'h22222222;
        data_in2 = 32'h33333333;
        data_in3 = 32'h44444444;
        select = 2'b10;
        #1;

        check_outputs(32'h33333333);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select data_in3", test_num);
        data_in0 = 32'h99999999;
        data_in1 = 32'h88888888;
        data_in2 = 32'h77777777;
        data_in3 = 32'h66666666;
        select = 2'b11;
        #1;

        check_outputs(32'h66666666);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: All Inputs Zero - Select 0", test_num);
        data_in0 = 32'h0;
        data_in1 = 32'h0;
        data_in2 = 32'h0;
        data_in3 = 32'h0;
        select = 2'b00;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: All Inputs All Fs - Select 2", test_num);
        data_in0 = 32'hFFFFFFFF;
        data_in1 = 32'hFFFFFFFF;
        data_in2 = 32'hFFFFFFFF;
        data_in3 = 32'hFFFFFFFF;
        select = 2'b10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Rapid select change (Switching 1 to 3)", test_num);
        data_in1 = 32'hBBBBBBBB;
        data_in3 = 32'hDDDDDDDD;
        select = 2'b01;
        #5;
        select = 2'b11;
        #1;

        check_outputs(32'hDDDDDDDD);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Alternating Bit Pattern", test_num);
        data_in0 = 32'h5555AAAA;
        data_in1 = 32'hAAAA5555;
        data_in2 = 32'hF0F0F0F0;
        data_in3 = 32'h0F0F0F0F;
        select = 2'b01;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_bus_mux Testbench");
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
        input [31:0] expected_data_out;
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
