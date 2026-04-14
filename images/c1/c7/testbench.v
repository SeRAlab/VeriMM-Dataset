`timescale 1ns/1ps

module memory_to_color_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] color_depth_i;
    reg [31:0] mem_i;
    reg [1:0] mem_lsb_i;
    wire [31:0] color_o;
    wire [3:0] sel_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_to_color dut (
        .color_depth_i(color_depth_i),
        .mem_i(mem_i),
        .mem_lsb_i(mem_lsb_i),
        .color_o(color_o),
        .sel_o(sel_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: 8-bit depth, LSB=0", test_num);
        mem_i = 32'hAABBCCDD;
        color_depth_i = 2'b00;
        mem_lsb_i = 2'b00;
        #1;

        check_outputs(32'h000000DD, 4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: 8-bit depth, LSB=1", test_num);
        mem_i = 32'hAABBCCDD;
        color_depth_i = 2'b00;
        mem_lsb_i = 2'b01;
        #1;

        check_outputs(32'h000000CC, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: 8-bit depth, LSB=2", test_num);
        mem_i = 32'hAABBCCDD;
        color_depth_i = 2'b00;
        mem_lsb_i = 2'b10;
        #1;

        check_outputs(32'h000000BB, 4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: 8-bit depth, LSB=3", test_num);
        mem_i = 32'hAABBCCDD;
        color_depth_i = 2'b00;
        mem_lsb_i = 2'b11;
        #1;

        check_outputs(32'h000000AA, 4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: 16-bit depth, Lower Half", test_num);
        mem_i = 32'h12345678;
        color_depth_i = 2'b01;
        mem_lsb_i = 2'b00;
        #1;

        check_outputs(32'h00005678, 4'b0011);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: 16-bit depth, Upper Half", test_num);
        mem_i = 32'h12345678;
        color_depth_i = 2'b01;
        mem_lsb_i = 2'b10;
        #1;

        check_outputs(32'h00001234, 4'b0011);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: 32-bit depth (10)", test_num);
        mem_i = 32'hDEADBEEF;
        color_depth_i = 2'b10;
        mem_lsb_i = 2'b00;
        #1;

        check_outputs(32'hDEADBEEF, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: 32-bit depth (11)", test_num);
        mem_i = 32'hCAFEBABE;
        color_depth_i = 2'b11;
        mem_lsb_i = 2'b00;
        #1;

        check_outputs(32'hCAFEBABE, 4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_to_color Testbench");
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
        input [31:0] expected_color_o;
        input [3:0] expected_sel_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_color_o === (expected_color_o ^ color_o ^ expected_color_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o)) begin
                $display("PASS");
                $display("  Outputs: color_o=%h, sel_o=%h",
                         color_o, sel_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_o=%h, sel_o=%h",
                         expected_color_o, expected_sel_o);
                $display("  Got:      color_o=%h, sel_o=%h",
                         color_o, sel_o);
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
