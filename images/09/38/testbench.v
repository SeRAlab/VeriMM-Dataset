`timescale 1ns/1ps

module mux_4_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg enable;
    reg [1:0] sel;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4_to_1 dut (
        .data_in(data_in),
        .enable(enable),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable low, output must be 0", test_num);
        enable = 1'b0;
        sel = 2'b11;
        data_in = 4'b1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=00, data_in[0]=1", test_num);
        enable = 1'b1;
        sel = 2'b00;
        data_in = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=00, data_in[0]=0", test_num);
        enable = 1'b1;
        sel = 2'b00;
        data_in = 4'b1110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=01, data_in[1]=1", test_num);
        enable = 1'b1;
        sel = 2'b01;
        data_in = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=01, data_in[1]=0", test_num);
        enable = 1'b1;
        sel = 2'b01;
        data_in = 4'b1101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=10, data_in[2]=1", test_num);
        enable = 1'b1;
        sel = 2'b10;
        data_in = 4'b0100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=10, data_in[2]=0", test_num);
        enable = 1'b1;
        sel = 2'b10;
        data_in = 4'b1011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=11, data_in[3]=1", test_num);
        enable = 1'b1;
        sel = 2'b11;
        data_in = 4'b1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable high, sel=11, data_in[3]=0", test_num);
        enable = 1'b1;
        sel = 2'b11;
        data_in = 4'b0111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable transition high -> low", test_num);
        enable = 1'b1;
        sel = 2'b01;
        data_in = 4'b1111;
        #5;
        enable = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4_to_1 Testbench");
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
        input expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
