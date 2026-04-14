`timescale 1ns/1ps

module stacks_mux_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] addr_sel_b_i;
    reg clk_i;
    reg [2:0] data_sel_a_i;
    reg [2:0] data_sel_b_i;
    reg [7:0] im_i;
    reg imad_i;
    reg imda_i;
    reg [31:0] pop_data0_i;
    reg [31:0] pop_data1_i;
    reg [31:0] pop_data2_i;
    reg [31:0] pop_data3_i;
    reg [31:0] pop_data4_i;
    reg [31:0] pop_data5_i;
    reg [31:0] pop_data6_i;
    reg [31:0] pop_data7_i;
    reg rst_i;
    wire [31:0] a_data_o;
    wire [15:0] b_addr_o;
    wire [31:0] b_data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stacks_mux dut (
        .addr_sel_b_i(addr_sel_b_i),
        .clk_i(clk_i),
        .data_sel_a_i(data_sel_a_i),
        .data_sel_b_i(data_sel_b_i),
        .im_i(im_i),
        .imad_i(imad_i),
        .imda_i(imda_i),
        .pop_data0_i(pop_data0_i),
        .pop_data1_i(pop_data1_i),
        .pop_data2_i(pop_data2_i),
        .pop_data3_i(pop_data3_i),
        .pop_data4_i(pop_data4_i),
        .pop_data5_i(pop_data5_i),
        .pop_data6_i(pop_data6_i),
        .pop_data7_i(pop_data7_i),
        .rst_i(rst_i),
        .a_data_o(a_data_o),
        .b_addr_o(b_addr_o),
        .b_data_o(b_data_o)
    );
    task testcase001;

        integer i;
        begin
            $display("Testcase 001: Testing a_data_o selection (0-7)");
            rst_i = 1; #10; rst_i = 0;


            pop_data0_i = 32'hAAAA_0000;
            pop_data1_i = 32'hBBBB_1111;
            pop_data2_i = 32'hCCCC_2222;
            pop_data3_i = 32'hDDDD_3333;
            pop_data4_i = 32'hEEEE_4444;
            pop_data5_i = 32'hFFFF_5555;
            pop_data6_i = 32'h1234_6666;
            pop_data7_i = 32'h5678_7777;
            imda_i = 0; imad_i = 0;

            for (i = 0; i < 8; i = i + 1) begin
                data_sel_a_i = i[2:0];
                #5;
                case(i)
                    0: #1;
 check_outputs(32'hAAAA_0000, 16'h0000, 32'h0000_0000);
                    1: #1;
 check_outputs(32'hBBBB_1111, 16'h0000, 32'h0000_0000);
                    2: #1;
 check_outputs(32'hCCCC_2222, 16'h0000, 32'h0000_0000);
                    3: #1;
 check_outputs(32'hDDDD_3333, 16'h0000, 32'h0000_0000);
                    4: #1;
 check_outputs(32'hEEEE_4444, 16'h0000, 32'h0000_0000);
                    5: #1;
 check_outputs(32'hFFFF_5555, 16'h0000, 32'h0000_0000);
                    6: #1;
 check_outputs(32'h1234_6666, 16'h0000, 32'h0000_0000);
                    7: #1;
 check_outputs(32'h5678_7777, 16'h0000, 32'h0000_0000);
                endcase
            end
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Testcase 002: Testing b_data_o selection (0-7)");
            rst_i = 1; #10; rst_i = 0;

            pop_data0_i = 32'h0000_AAAA;
            pop_data1_i = 32'h1111_BBBB;
            pop_data2_i = 32'h2222_CCCC;
            pop_data3_i = 32'h3333_DDDD;
            pop_data4_i = 32'h4444_EEEE;
            pop_data5_i = 32'h5555_FFFF;
            pop_data6_i = 32'h6666_1234;
            pop_data7_i = 32'h7777_5678;
            imda_i = 0;

            for (i = 0; i < 8; i = i + 1) begin
                data_sel_b_i = i[2:0];
                #5;
                case(i)
                    0: #1;
 check_outputs(a_data_o, b_addr_o, 32'h0000_AAAA);
                    1: #1;
 check_outputs(a_data_o, b_addr_o, 32'h1111_BBBB);
                    2: #1;
 check_outputs(a_data_o, b_addr_o, 32'h2222_CCCC);
                    3: #1;
 check_outputs(a_data_o, b_addr_o, 32'h3333_DDDD);
                    4: #1;
 check_outputs(a_data_o, b_addr_o, 32'h4444_EEEE);
                    5: #1;
 check_outputs(a_data_o, b_addr_o, 32'h5555_FFFF);
                    6: #1;
 check_outputs(a_data_o, b_addr_o, 32'h6666_1234);
                    7: #1;
 check_outputs(a_data_o, b_addr_o, 32'h7777_5678);
                endcase
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Testing b_addr_o selection (lower 16 bits)");
            rst_i = 1; #10; rst_i = 0;

            pop_data0_i = 32'h1234_5678;
            pop_data1_i = 32'hABCD_EF01;
            pop_data2_i = 32'hAAAA_BBBB;
            pop_data3_i = 32'hCCCC_DDDD;
            pop_data4_i = 32'hEEEE_FFFF;
            pop_data5_i = 32'h0000_1111;
            pop_data6_i = 32'h2222_3333;
            pop_data7_i = 32'h4444_5555;
            imad_i = 0;

            for (i = 0; i < 8; i = i + 1) begin
                addr_sel_b_i = i[2:0];
                #5;
                case(i)
                    0: #1;
 check_outputs(a_data_o, 16'h5678, b_data_o);
                    1: #1;
 check_outputs(a_data_o, 16'hEF01, b_data_o);
                    2: #1;
 check_outputs(a_data_o, 16'hBBBB, b_data_o);
                    3: #1;
 check_outputs(a_data_o, 16'hDDDD, b_data_o);
                    4: #1;
 check_outputs(a_data_o, 16'hFFFF, b_data_o);
                    5: #1;
 check_outputs(a_data_o, 16'h1111, b_data_o);
                    6: #1;
 check_outputs(a_data_o, 16'h3333, b_data_o);
                    7: #1;
 check_outputs(a_data_o, 16'h5555, b_data_o);
                endcase
            end
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Testing b_data_o immediate injection");
            rst_i = 1; #10; rst_i = 0;

            pop_data0_i = 32'hFFFF_FFFF;
            data_sel_b_i = 3'b000;
            im_i = 8'hA5;
            imda_i = 1;

            #5;

            #1;


            check_outputs(a_data_o, b_addr_o, 32'h0000_00A5);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Testing b_addr_o immediate injection");
            rst_i = 1; #10; rst_i = 0;

            pop_data3_i = 32'hFFFF_FFFF;
            addr_sel_b_i = 3'b011;
            im_i = 8'h5A;
            imad_i = 1;

            #5;

            #1;


            check_outputs(a_data_o, 16'h005A, b_data_o);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Testing simultaneous operations");
            rst_i = 1; #10; rst_i = 0;

            pop_data0_i = 32'h1111_1111;
            pop_data1_i = 32'h2222_2222;
            pop_data2_i = 32'h3333_3333;

            data_sel_a_i = 3'b000;
            data_sel_b_i = 3'b001;
            addr_sel_b_i = 3'b010;

            im_i = 8'hFF;
            imda_i = 0;
            imad_i = 0;
            #5;
            #1;

            check_outputs(32'h1111_1111, 16'h3333, 32'h2222_2222);


            imda_i = 1;
            imad_i = 1;
            #5;
            #1;

            check_outputs(32'h1111_1111, 16'h00FF, 32'h0000_00FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stacks_mux Testbench");
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
        input [31:0] expected_a_data_o;
        input [15:0] expected_b_addr_o;
        input [31:0] expected_b_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_data_o === (expected_a_data_o ^ a_data_o ^ expected_a_data_o) &&
                expected_b_addr_o === (expected_b_addr_o ^ b_addr_o ^ expected_b_addr_o) &&
                expected_b_data_o === (expected_b_data_o ^ b_data_o ^ expected_b_data_o)) begin
                $display("PASS");
                $display("  Outputs: a_data_o=%h, b_addr_o=%h, b_data_o=%h",
                         a_data_o, b_addr_o, b_data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_data_o=%h, b_addr_o=%h, b_data_o=%h",
                         expected_a_data_o, expected_b_addr_o, expected_b_data_o);
                $display("  Got:      a_data_o=%h, b_addr_o=%h, b_data_o=%h",
                         a_data_o, b_addr_o, b_data_o);
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
