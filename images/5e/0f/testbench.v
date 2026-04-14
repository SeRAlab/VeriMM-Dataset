`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] d_address;
    reg [31:0] d_readdatain;
    reg load_sign_ext;
    reg [1:0] load_size;
    wire [31:0] d_loadresult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_address(d_address),
        .d_readdatain(d_readdatain),
        .load_sign_ext(load_sign_ext),
        .load_size(load_size),
        .d_loadresult(d_loadresult)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Byte 0, Unsigned", test_num);
            d_readdatain = 32'h12345678;
            d_address = 2'b00;
            load_size = 2'b00;
            load_sign_ext = 1'b0;
            #1;

            check_outputs(32'h00000078);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Byte 1, Unsigned", test_num);
            d_readdatain = 32'h12345678;
            d_address = 2'b01;
            load_size = 2'b00;
            load_sign_ext = 1'b0;
            #1;

            check_outputs(32'h00000056);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Byte 2, Unsigned", test_num);
            d_readdatain = 32'h12345678;
            d_address = 2'b10;
            load_size = 2'b00;
            load_sign_ext = 1'b0;
            #1;

            check_outputs(32'h00000034);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Byte 3, Unsigned", test_num);
            d_readdatain = 32'h12345678;
            d_address = 2'b11;
            load_size = 2'b00;
            load_sign_ext = 1'b0;
            #1;

            check_outputs(32'h00000012);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Byte 0, Signed (Negative)", test_num);
            d_readdatain = 32'h0000008A;
            d_address = 2'b00;
            load_size = 2'b00;
            load_sign_ext = 1'b1;
            #1;

            check_outputs(32'hFFFFFF8A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Byte 2, Signed (Positive)", test_num);
            d_readdatain = 32'h00450000;
            d_address = 2'b10;
            load_size = 2'b00;
            load_sign_ext = 1'b1;
            #1;

            check_outputs(32'h00000045);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Half-word 0, Unsigned", test_num);
            d_readdatain = 32'h12345678;
            d_address = 2'b00;
            load_size = 2'b01;
            load_sign_ext = 1'b0;
            #1;

            check_outputs(32'h00005678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Half-word 1, Signed (Negative)", test_num);
            d_readdatain = 32'hABCD1234;
            d_address = 2'b10;
            load_size = 2'b01;
            load_sign_ext = 1'b1;
            #1;

            check_outputs(32'hFFFFABCD);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Full Word", test_num);
            d_readdatain = 32'hDEADBEEF;
            d_address = 2'b00;
            load_size = 2'b10;
            load_sign_ext = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Full Word (Signed flag set)", test_num);
            d_readdatain = 32'h80000000;
            d_address = 2'b00;
            load_size = 2'b10;
            load_sign_ext = 1'b1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_d_loadresult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_loadresult === (expected_d_loadresult ^ d_loadresult ^ expected_d_loadresult)) begin
                $display("PASS");
                $display("  Outputs: d_loadresult=%h",
                         d_loadresult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_loadresult=%h",
                         expected_d_loadresult);
                $display("  Got:      d_loadresult=%h",
                         d_loadresult);
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
